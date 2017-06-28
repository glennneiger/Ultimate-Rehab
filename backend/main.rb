require 'json'
require 'securerandom'
require 'date'
require 'yaml'

require 'scrypt'
require 'stripe'
require 'pony'
require 'sinatra'
require 'sinatra/reloader'
require 'dry-validation'

require_relative 'util'
require_relative 'template_api'
require_relative 'product_templates'
require_relative 'room_templates'

set :port, CONFIG['backend_port']
set :bind, CONFIG['backend_ip']
set :show_exceptions, :after_handler
set :raise_errors, false
set :show_exceptions, false

# enable CORS
before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end
options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
end

# error handlers
not_found do
    status 404
    content_type :json
    return {status: "not found"}.to_json
end

error do
    puts 'Sorry there was a nasty error - ' + env['sinatra.error'].message
    status 500
    content_type :json
    return {status: "error"}.to_json
end

def pgParseBool(x)
    x == 't'
end

def trxFail(output, status, response)
    output[:status] = status
    output[:response] = response
    raise Sequel::Rollback
end

#####################
#       User        #
#####################

NO_ACCOUNT = 'no account'
UNVERIFIED_ACCOUNT = 'unverified'
LIMITED_ACCOUNT = 'limited'
FULL_ACCOUNT = 'full'
SUSPENDED_ACCOUNT = 'suspended' # User exists but no valid subscription
HAS_ACCOUNT = [UNVERIFIED_ACCOUNT, LIMITED_ACCOUNT, FULL_ACCOUNT, SUSPENDED_ACCOUNT]
HAS_VALID_ACCOUNT = [LIMITED_ACCOUNT, FULL_ACCOUNT]

def normalizeAccountStatus(verified, current_sub_type)
    if verified == false
        return [true, UNVERIFIED_ACCOUNT]
    elsif current_sub_type.nil?
        return [true, SUSPENDED_ACCOUNT]
    end

    if HAS_ACCOUNT.include?(current_sub_type)
        return [true, current_sub_type]
    end

    return [false, nil]
end

def authorize(user_id, access_token, sufficient_auths)
    days_since_epoch = daysSinceEpoch
    getConn do |c|
        z = c[:users].
                left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
                where(:users__id => user_id,
                      :users__access_token => access_token).
                select(:users__verified, :subscriptions__sub_type, :subscriptions__sub_end_day).first
        if z.nil?
            return sufficient_auths.include?(NO_ACCOUNT)
        end
        verified = z[:verified]
        sub_type = z[:sub_type]
        sub_end_day = z[:sub_end_day]
        if sub_type.nil? or sub_end_day.nil? or sub_end_day <= days_since_epoch
            sub_type = nil
        end

        status, account_status = normalizeAccountStatus(verified, sub_type)
        if status == false
            return false
        end
        return sufficient_auths.include?(account_status)
    end
end

def authorizeWithProperties(user_id, access_token, sufficient_auths, property_ids)
    days_since_epoch = daysSinceEpoch
    getConn do |c|
        z = c[:users].
                join(:properties, :users__id => :properties__user_id).
                left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
                where(:users__id => user_id,
                      :users__access_token => access_token,
                      :properties__id => property_ids).
                select(:users__verified, :subscriptions__sub_type, :subscriptions__sub_end_day).
                first
        if z.nil?
            return false
        end
        verified = z[:verified]
        sub_type = z[:sub_type]
        sub_end_day = z[:sub_end_day]
        if sub_type.nil? or sub_end_day.nil? or sub_end_day <= days_since_epoch
            sub_type = nil
        end

        status, account_status = normalizeAccountStatus(verified, sub_type)
        if status == false
            return false
        end
        return sufficient_auths.include?(account_status)
    end
end

def authorizeWithRooms(user_id, access_token, sufficient_auths, room_ids)
    days_since_epoch = daysSinceEpoch
    getConn do |c|
        z = c[:users].
                join(:rooms, :users__id => :rooms__user_id).
                left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
                where(:users__id => user_id,
                      :users__access_token => access_token,
                      :rooms__id => room_ids).
                select(:users__verified, :subscriptions__sub_type, :subscriptions__sub_end_day).first
        if z.nil?
            return false
        end
        verified = z[:verified]
        sub_type = z[:sub_type]
        sub_end_day = z[:sub_end_day]
        if sub_type.nil? or sub_end_day.nil? or sub_end_day <= days_since_epoch
            sub_type = nil
        end

        status, account_status = normalizeAccountStatus(verified, sub_type)
        if status == false
            return false
        end
        return sufficient_auths.include?(account_status)
    end
end

get "/user/:user_id" do |user_id|
    user_id = user_id.to_i
    access_token = params["access_token"]
    Schema = Dry::Validation.Schema do
        required('access_token') {filled? & str?}
        required('user_id') {filled? & int? & gt?(0)}
    end
    x = Schema.({'user_id' => user_id, 'access_token' => access_token})
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    if !authorize(user_id, access_token, HAS_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    days_since_epoch = daysSinceEpoch
    getConn do |c|
        z = c[:users].
                left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
                where(:users__id => user_id).
                select(:users__email, :users__admin, :users__stripe_customer_id,
                       :users__stripe_autorenew, :users__verified,
                       :subscriptions__sub_type, :subscriptions__sub_end_day).first
        if z.nil?
            content_type :json
            status 404
            return {error: NO_ACCOUNT}.to_json
        end
        email = z[:email]
        admin = z[:admin]
        stripe_customer_id = z[:stripe_customer_id]
        stripe_autorenew = z[:stripe_autorenew]
        verified = z[:verified]
        sub_type = z[:sub_type]
        sub_end_day = z[:sub_end_day]

        if sub_type.nil? or sub_end_day.nil?
            sub_type = nil
            pretty_active_sub_end_date = nil
        else
            sub_type = sub_type
            pretty_active_sub_end_date = daysSinceEpochToDate(sub_end_day).strftime("%B %e, %Y")
        end

        status, account_status = normalizeAccountStatus(verified, sub_type)
        if status == false
            content_type :json
            status 500
            return {status: "unknown status"}.to_json
        end

        pretty_credit_card = nil
        if stripe_autorenew == false
            pretty_credit_card = nil
        else
            begin
                x = Stripe::Customer.retrieve(stripe_customer_id)
                x["sources"]["data"].each do |y|
                    if y["id"] == x["default_source"]
                        pretty_credit_card = "#{y["brand"]} #{y["last4"]}"
                    end
                end
            rescue Stripe::StripeError => e
                puts e
                pretty_credit_card = nil
            end
        end

        content_type :json
        return {
            user_id: user_id,
            email: email,
            admin: admin,
            auth: account_status,
            stripe_customer_id: stripe_customer_id,
            active_sub_end_date: pretty_active_sub_end_date,
            pretty_credit_card: pretty_credit_card,
        }.to_json
    end
end

# There are only two states for credit cards.
# 0. The account has a card and we autorenew the subscription.
# 1. The account does not have a card and we do not autorenew the subscription.
post "/user" do
    j = JSON.parse(request.body.read)
    Schema = Dry::Validation.Schema do
        required('name') {filled? & str?}
        required('email') {filled? & str?}
        required('stripe_card_token') {filled? & str?}
        required('password') {filled? & str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    name = j["name"]
    email = j["email"]
    stripe_card_token = j["stripe_card_token"]
    password = j["password"]

    password = SCrypt::Password.create(password)
    days_since_epoch = daysSinceEpoch
    transaction_failure = {}
    getConn do |c| c.transaction do
        z = c[:users].
            where(Sequel.function(:lower, :email) => email.downcase).
            select(:users__id, :users__verified, :users__verification_token).
            first
        verification_token, user_id =
            if !z.nil?
                user_id = z[:id]
                verified = z[:verified]
                verification_token = z[:verification_token]

                if verified == true
                    trxFail(transaction_failure, 409, {error: "account already exists"})
                end

                # Resend verification email if the user tries to
                # re-register an unverified account.
                # XXX: Update the user's password. This could potentially
                # be abused by a malicious user keeps changing your
                # password before you can complete verification.
                #
                # We don't update the Stripe data. If the user enters a
                # different card the second time we ignore it.
                z = c[:users].
                    where{(users[:id] =~ user_id) \
                        & (users[:verified] =~ false) \
                        & (users[:verification_token] =~ verification_token)}.
                    update(:password => password)
                if z < 1
                    trxFail(transaction_failure, 404, {error: NO_ACCOUNT})
                end

                [verification_token, user_id]
            else
                # Create new account with limited subscription.
                verification_token = SecureRandom.hex(20)
                access_token = SecureRandom.hex(20)
                access_token_expire = Time.now.to_i + ACCESS_TOKEN_SECONDS_VALID

                stripe_customer_id = nil
                begin
                    x = Stripe::Customer.create(
                        :description => "UltimateRehabEstimator/Customer/#{email}",
                        :source => stripe_card_token
                    )
                    stripe_customer_id = x.id
                rescue Stripe::StripeError => e
                    puts e
                    trxFail(transaction_failure, 409, {error: "failed to create stripe customer"})
                end

                # HACK: circular reference
                y = c[:users].
                    insert(:name => name, :email => email, :password => password,
                           :admin => false, :verification_token => verification_token,
                           :verified => false, :access_token => access_token,
                           :access_token_expire => access_token_expire,
                           :stripe_customer_id => stripe_customer_id,
                           :stripe_autorenew => true,
                           :current_sub_id => nil)
                z = c[:subscriptions].
                    insert(:user_id => y, :amount_paid => 0,
                           :payment_day => days_since_epoch,
                           :sub_type => 'limited',
                           :sub_end_day => days_since_epoch + LIMITED_SUBSCRIPTION_DAYS,
                           :renewal_email_sent => false)
                c[:users].where(:id => y).update(:current_sub_id => z)

                [verification_token, y]
            end

        link = "#{CONFIG['frontend_public_address']}/verify?verification_token=#{verification_token}&user_id=#{user_id}"
        if SEND_EMAILS == true
            sendEmail(email, 'Welcome', "Click the verification link: #{link}")
        end
        puts "LINK: #{link}"
        if SEND_EMAILS == true
            content_type :json
            return {ok: "ok"}.to_json
        else
            content_type :json
            return {ok: "ok", link: link}.to_json
        end
    end end

    content_type :json
    status transaction_failure[:status]
    return transaction_failure[:response].to_json
end

put "/user/:user_id/verify" do |user_id|
    user_id = user_id.to_i
    j = JSON.parse(request.body.read)
    j['user_id'] = user_id
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('verification_token') {filled? & str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    verification_token = j["verification_token"]

    getConn do |c|
        z = c[:users].
            where{(users[:id] =~ user_id) \
                & (users[:verified] =~ false) \
                & (users[:verification_token] =~ verification_token)}.
            update(:verified => true)
        if z < 1
            content_type :json
            status 404
            return {error: NO_ACCOUNT}.to_json
        end

        content_type :json
        return { ok: 'ok' }.to_json
    end
end

# Add new credit card to account.
post "/user/:user_id/creditcard" do |user_id|
    user_id = user_id.to_i
    j = JSON.parse(request.body.read)
    j['user_id'] = user_id
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
        required('stripe_card_token') {filled? & str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    access_token = j["access_token"]
    stripe_card_token = j["stripe_card_token"]

    if !authorize(user_id, access_token, HAS_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    transaction_failure = {}
    getConn do |c| c.transaction do
        z = c[:users].where(:id => user_id).select(:users__stripe_customer_id).first
        if z.nil?
            trxFail(transaction_failure, 404, {error: "active sub"})
        end
        stripe_customer_id = z[:stripe_customer_id]

        begin
            # This will override existing cards.
            x = Stripe::Customer.retrieve(stripe_customer_id)
            x.source = stripe_card_token
            x.save

            # Always set autorenew when we get a new card.
            c[:users].where(:id => user_id).update(:stripe_autorenew => true)

            content_type :json
            return { ok: "ok" }.to_json
        rescue Stripe::StripeError => e
            puts e
            trxFail(transaction_failure, 500, {error: "generic stripe error"})
        end
    end end

    content_type :json
    status transaction_failure[:status]
    return transaction_failure[:response].to_json
end

# Disables autorenew
delete "/user/:user_id/creditcard" do |user_id|
    user_id = user_id.to_i
    j = JSON.parse(request.body.read)
    j['user_id'] = user_id
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    access_token = j['access_token']

    if !authorize(user_id, access_token, HAS_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    getConn do |c|
        z = c[:users].where(:id => user_id).update(:stripe_autorenew => false)
        if z < 1
            content_type :json
            status 404
            return {error: NO_ACCOUNT}.to_json
        end

        content_type :json
        return { status: 'ok' }.to_json
    end
end

# Create a new subscription if there is no active subscription 7 days from
# today.
post "/user/:user_id/subscription" do |user_id|
    user_id = user_id.to_i
    j = JSON.parse(request.body.read)
    j['user_id'] = user_id
    Schema = Dry::Validation.Schema do
        required('access_token') {filled? & str?}
        required('user_id') {filled? & int? & gt?(0)}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    access_token = j['access_token']

    if !authorize(user_id, access_token, HAS_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    transaction_failure = {}
    days_since_epoch = daysSinceEpoch
    getConn do |c| c.transaction do
        # Is the current subscription expired/expiring?
        z = c[:users].
                left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
                where{(users[:id] =~ user_id) \
                      & (days_since_epoch + 1 >= subscriptions[:sub_end_day]) \
                      & (users[:stripe_autorenew] =~ true)}.
                select(:users__stripe_customer_id, :subscriptions__sub_end_day).
                first
        if z.nil?
            trxFail(transaction_failure, 550, {error: "no sub required"})
        end
        x = newSubscription!(c, user_id, days_since_epoch, z[:sub_end_day],
            z[:stripe_customer_id])
        if x == false
            trxFail(transaction_failure, 500, {error: "card declined"})
        end

        content_type :json
        return {ok: 'ok'}.to_json
    end end

    content_type :json
    status transaction_failure[:status]
    return transaction_failure[:response].to_json
end

post "/public/user/:email/login" do |email|
    j = JSON.parse(request.body.read)
    j['email'] = email
    Schema = Dry::Validation.Schema do
        required('email') {filled? & str?}
        required('password') {filled? & str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    password = j['password']

    days_since_epoch = daysSinceEpoch
    getConn do |c|
        z = c[:users].
                left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
                where(Sequel.function(:lower, :users__email) => email.downcase).
                select(:users__id, :users__verified, :users__access_token,
                       :users__access_token_expire, :users__password,
                       :subscriptions__sub_type, :subscriptions__sub_end_day).first
        if z.nil?
            content_type :json
            status 404
            return {error: NO_ACCOUNT}.to_json
        end
        user_id = z[:id]
        verified = z[:verified]
        access_token = z[:access_token]
        access_token_expire = z[:access_token_expire]
        stretched_password = z[:password]
        sub_type = z[:sub_type]
        sub_end_day = z[:sub_end_day]
        if sub_type.nil? or sub_end_day.nil? or sub_end_day <= days_since_epoch
            sub_type = nil
        end

        status, account_status = normalizeAccountStatus(verified, sub_type)
        if status == false
            content_type :json
            status 500
            return { status: 'error: unknown account status' }.to_json
        end

        if SCrypt::Password.new(stretched_password) != password
            content_type :json
            status 400
            return {error: "bad password"}.to_json
        end

        # Update the access token when expired.  The user has provided his
        # password so it's safe to create a new access token for him. The new
        # token is available to all accounts (even unverified or suspended).
        if access_token_expire < Time.now.to_i
            getConn do |c|
                c[:users].
                    where(:id => user_id).
                    update(:access_token => SecureRandom.hex(20),
                           :access_token_expire => Time.now.to_i + ACCESS_TOKEN_SECONDS_VALID)
            end
        end

        content_type :json
        return {
            access_token: access_token,
            user_id: user_id,
            email: email,
            auth: account_status,
        }.to_json
    end
end

get "/public/user/:email/passwordReset" do |email|
    Schema = Dry::Validation.Schema do
        required('email') {filled? & str?}
    end
    x = Schema.({'email' => email})
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    password_reset_token = SecureRandom.hex(20)
    password_reset_expire = Time.now.to_i + PASSWORD_RESET_TOKEN_SECONDS_VALID
    user_id = nil
    getConn do |c|
        z = c[:users].
            returning(:id).
            where(Sequel.function(:lower, :email) => email.downcase).
            update(:password_reset_token => password_reset_token,
                   :password_reset_expire => password_reset_expire).
            first
        user_id = (z || {})[:id]
    end
    if user_id.nil?
        content_type :json
        status 404
        return {error: NO_ACCOUNT}.to_json
    end

    link = "#{CONFIG['frontend_public_address']}/passwordReset/finish?password_reset_token=#{password_reset_token}&user_id=#{user_id}"
    if SEND_EMAILS == true
        sendEmail(email, 'Password Reset', "Click the reset link: #{link}")
    end
    puts "LINK: #{link}"
    if SEND_EMAILS == true
        content_type :json
        return {ok: "ok"}.to_json
    else
        content_type :json
        return {ok: "ok", link: link}.to_json
    end
end

put "/user/:user_id/passwordReset/verify" do |user_id|
    user_id = user_id.to_i
    j = JSON.parse(request.body.read)
    j['user_id'] = user_id
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('password_reset_token') {filled? & str?}
        required('password') {filled? & str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    password_reset_token = j["password_reset_token"]
    new_password = j["password"]

    new_password = SCrypt::Password.create(new_password)
    getConn do |c|
        z = c[:users].
            where{(users[:id] =~ user_id) \
                & (users[:password_reset_token] =~ password_reset_token) \
                & (users[:password_reset_expire] > Time.now.to_i)}.
            update(:password_reset_token => nil,
                   :password_reset_expire => 0,
                   :password => new_password)
        if z < 1
            content_type :json
            status 404
            return {error: NO_ACCOUNT}.to_json
        end

        content_type :json
        return { ok: 'ok' }.to_json
    end
end

put "/user/:user_id/passwordReset" do |user_id|
    user_id = user_id.to_i
    j = JSON.parse(request.body.read)
    j['user_id'] = user_id
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('current_password') {filled? & str?}
        required('new_password') {filled? & str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    current_password = j["current_password"]
    new_password = j["new_password"]

    new_password = SCrypt::Password.create(new_password)
    transaction_failure = {}
    getConn do |c| c.transaction do
        z = c[:users].
            where(:id => user_id).
            select(:password).
            first
        if z.nil?
            trxFail(transaction_failure, 404, {error: NO_ACCOUNT})
        end
        stretched_current_password = SCrypt::Password.new(z[:password])
        if stretched_current_password != current_password
            trxFail(transaction_failure, 400, {error: "bad password"})
        end

        z = c[:users].
            where(:id => user_id).
            update(:password_reset_token => nil,
                   :password_reset_expire => 0,
                   :password => new_password)
        if z < 1
            trxFail(transaction_failure, 404, {error: NO_ACCOUNT})
        end

        content_type :json
        return { status: 'ok', }.to_json
    end end

    content_type :json
    status transaction_failure[:status]
    return transaction_failure[:response].to_json
end

delete "/user/:user_id" do |user_id|
    user_id = user_id.to_i
    access_token = params['access_token']
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
    end
    x = Schema.({'user_id' => user_id, 'access_token' => access_token})
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    if !authorize(user_id, access_token, HAS_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    transaction_failure = {}
    getConn do |c| c.transaction do
        c[:measurements].where(:room_id => c[:rooms].where(:user_id => user_id).select(:room_id)).delete
        c[:rooms].where(:user_id => user_id).delete
        c[:properties].where(:user_id => user_id).delete
        c[:subscriptions].where(:user_id => user_id).delete
        z = c[:users].where(:id => user_id).delete
        if z < 1
            trxFail(transaction_failure, 404, {error: NO_ACCOUNT})
        end

        content_type :json
        return { status: 'ok' }.to_json
    end end

    content_type :json
    status transaction_failure[:status]
    return transaction_failure[:response].to_json
end

#####################
#      Property     #
#####################
# fetch all properties (for user)
get "/property" do
    user_id = params["user_id"].to_i
    access_token = params["access_token"]
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
    end
    x = Schema.({'user_id' => user_id, 'access_token' => access_token})
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    # HACK: This could rightfully be set to `HAS_VALID_ACCOUNT`; but using
    # `HAS_ACCOUNT` simplifies the private header for unverified/suspended
    # accounts.
    if !authorize(user_id, access_token, HAS_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    properties = {}
    getConn do |c|
        c[:properties].left_outer_join(:rooms, :properties__id => :rooms__property_id).
        where(:properties__user_id => user_id).
        select(:properties__id___p_id, :properties__address, :properties__city,
                 :properties__state, :properties__zip_code,
                 :properties__sq_feet_above, :properties__sq_feet_below,
                 :properties__floors, :properties__vacant,
                 :properties__year_built, :properties__notes,
                 :properties__financing, :rooms__id___r_id,
                 :rooms__template_id___r_template_id, :rooms__name).
        map do |row|
            property_id = row[:p_id]
            address = row[:address]
            city = row[:city]
            state = row[:state]
            zip_code = row[:zip_code]
            sq_feet_above = row[:sq_feet_above]
            sq_feet_below = row[:sq_feet_below]
            floors = row[:floors]
            vacant = row[:vacant]
            year_built = row[:year_built]
            financing = JSON.parse(row[:financing] || '{}')
            notes = row[:notes]
            room_id = row[:r_id]
            room_template_id = row[:r_template_id]
            room_name = row[:name]

            if properties[property_id].nil?
                properties[property_id] = {
                    'id' => property_id,
                    'address' => address,
                    'city' => city,
                    'state' => state,
                    'zip_code' => zip_code,
                    'sq_feet_above' => sq_feet_above,
                    'sq_feet_below' => sq_feet_below,
                    'floors' => floors,
                    'vacant' => vacant,
                    'year_built' => year_built,
                    'financing' => financing,
                    'notes' => notes,
                    'rooms' => {},
                }
            end

            if !room_id.nil? and !room_template_id.nil?
                room_id = room_id.to_i
                room_template = ROOM_TEMPLATES[room_template_id.to_sym]

                if !room_template.nil?
                    properties[property_id]['rooms'][room_id] = {
                        'id' => room_id,
                        'template_id' => room_template_id,
                        'name' => room_name,
                    }
                end
            end
        end

        content_type :json
        return properties.to_json
    end
end

# Create new property
post "/property" do
    j = JSON.parse(request.body.read)
    Schema = Dry::Validation.Schema do
        required('access_token') {filled? & str?}
        required('user_id') {filled? & int? & gt?(0)}
        required('address') {str?}
        required('city') {str?}
        required('state') {str?}
        required('zip_code') {str?}
        required('sq_feet_above') {int?}
        required('sq_feet_below') {int?}
        required('floors') {int?}
        required('vacant') {bool?}
        required('year_built') {int?}
        required('notes') {str?}
        required('financing') {hash?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    access_token = j["access_token"]
    user_id = j["user_id"]
    address = j["address"]
    city = j["city"]
    state = j["state"]
    zip_code = j["zip_code"]
    sq_feet_above = j["sq_feet_above"]
    sq_feet_below = j["sq_feet_below"]
    floors = j["floors"]
    vacant = j["vacant"]
    year_built = j["year_built"]
    notes = j["notes"]
    financing = j["financing"]

    if !authorize(user_id, access_token, HAS_VALID_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    transaction_failure = {}
    getConn do |c| c.transaction do
        z = c[:properties].where(:user_id => user_id).count
        if z >= CONFIG['max_properties']
            trxFail(transaction_failure, 500, {error: "too many properties"})
        end

        z = c[:properties].
            insert(:user_id => user_id, :address => address, :city => city,
                   :state => state, :zip_code => zip_code,
                   :sq_feet_above => sq_feet_above,
                   :sq_feet_below => sq_feet_below, :floors => floors,
                   :vacant => vacant, :year_built => year_built,
                   :notes => notes, :financing => JSON.dump(financing))

        content_type :json
        return {
            id: z,
            address: address,
            city: city,
            state: state,
            zip_code: zip_code,
            sq_feet_above: sq_feet_above,
            sq_feet_below: sq_feet_below,
            floors: floors,
            vacant: vacant,
            year_built: year_built,
            notes: notes,
            financing: financing,
        }.to_json
    end end

    content_type :json
    status transaction_failure[:status]
    return transaction_failure[:response].to_json
end

# Update existing properties
put "/property" do
    j = JSON.parse(request.body.read)
    Schema = Dry::Validation.Schema do
        required('access_token') {filled? & str?}
        required('user_id') {filled? & int? & gt?(0)}
        required('properties').schema do
            optional('address') {str?}
            optional('city') {str?}
            optional('state') {str?}
            optional('zip_code') {str?}
            optional('sq_feet_above') {int?}
            optional('sq_feet_below') {int?}
            optional('floors') {int?}
            optional('vacant') {bool?}
            optional('year_built') {int?}
            optional('notes') {str?}
            optional('financing') {hash?}
        end
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    access_token = j["access_token"]
    user_id = j["user_id"]
    properties = j["properties"]

    property_ids = properties.map {|property_id, _| property_id}
    if !authorizeWithProperties(user_id, access_token, HAS_VALID_ACCOUNT, property_ids)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    # TODO: Use single query
    transaction_failure = {}
    getConn do |c| c.transaction do
        properties.each do |property_id, property|
            property_id = property_id

            columns = {}
            if property.key?("address")
                columns['address'] = property['address']
            end
            if property.key?("city")
                columns['city'] = property['city']
            end
            if property.key?("state")
                columns['state'] = property['state']
            end
            if property.key?("zip_code")
                columns['zip_code'] = property['zip_code']
            end
            if property.key?("sq_feet_above")
                columns['sq_feet_above'] = property['sq_feet_above']
            end
            if property.key?("sq_feet_below")
                columns['sq_feet_below'] = property['sq_feet_below']
            end
            if property.key?("floors")
                columns['floors'] = property['floors']
            end
            if property.key?("vacant")
                columns['vacant'] = property['vacant']
            end
            if property.key?("year_built")
                columns['year_built'] = property['year_built']
            end
            if property.key?("notes")
                columns['notes'] = property['notes']
            end
            if property.key?('financing')
                columns['financing'] = JSON.dump(property['financing'])
            end

            z = c[:properties].
                where(:id => property_id, :user_id => user_id).
                update(columns)
            if z < 1
                trxFail(transaction_failure, 404, {error: NO_ACCOUNT})
            end
        end

        content_type :json
        return {ok: "ok"}.to_json
    end end

    content_type :json
    status transaction_failure[:status]
    return transaction_failure[:response].to_json
end

# Fetch all measurements/rooms on a given property
get "/property/:property_id" do |property_id|
    property_id = property_id.to_i
    access_token = params["access_token"]
    user_id = params["user_id"].to_i
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
        required('property_id') {filled? & int? & gt?(0)}
    end
    x = Schema.({
        'user_id' => user_id,
        'access_token' => access_token,
        'property_id' => property_id,
    })
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    if !authorizeWithProperties(user_id, access_token, HAS_VALID_ACCOUNT, [property_id])
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    getConn do |c|
        rooms = {}

        # Get products
        c[:rooms].left_outer_join(:products, :rooms__id => :products__room_id).
        where(:property_id => property_id, :user_id => user_id).
        select(:rooms__id, :rooms__template_id, :rooms__name,
               :products__template_id___product_template_id, :products__details,
               :products__section).map do |row|
            room_id = row[:id]
            room_template_id = row[:template_id]
            room_name = row.fetch(:name, '')
            product_template_id = row[:product_template_id]
            # Only consider the 'first' detail.
            detail_name, detail_value = JSON.parse(row[:details] || '{}').first
            section_name = row[:section]

            rooms[room_id] = rooms[room_id] || basicRoom(room_template_id, room_id, property_id, room_name)

            # Add product data
            if product_template_id and !section_name.nil? and !detail_name.nil?
                sections = rooms[room_id][:sections]
                if !sections.key?(section_name)
                    sections[section_name] = {
                        name: section_name,
                        products: {}
                    }
                end

                sections[section_name][:products][product_template_id] = {
                    detail: {
                        name: detail_name,
                        value: detail_value
                    }
                }
            end
        end

        # Get measurements
        c[:rooms].join(:measurements, :rooms__id => :measurements__room_id).
        where(:property_id => property_id, :user_id => user_id).
        select(:rooms__id, :measurements__name, :measurements__value).map do |row|
            room_id = row[:id]
            name = row[:name]
            value = row[:value]

            r = rooms[room_id]
            next if r.nil?

            r[:measurements][name] = { :name => name, :value => value }
        end

        content_type :json
        return rooms.to_json
    end
end

delete "/property/:property_id" do |property_id|
    property_id = property_id.to_i
    access_token = params["access_token"]
    user_id = params["user_id"].to_i
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
        required('property_id') {filled? & int? & gt?(0)}
    end
    x = Schema.({
        'user_id' => user_id,
        'access_token' => access_token,
        'property_id' => property_id,
    })
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    if !authorizeWithProperties(user_id, access_token, HAS_VALID_ACCOUNT, [property_id])
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    getConn do |c| c.transaction do
        c[:measurements].
        where(:room_id => c[:rooms].where(:property_id => property_id, :user_id => user_id).select(:room_id)).delete

        c[:rooms].
        where{(rooms[:property_id] =~ property_id) & (rooms[:user_id] =~ user_id)}.
        delete

        c[:properties].
        where{(properties[:id] =~ property_id) & (properties[:user_id] =~ user_id)}.
        delete

        content_type :json
        return { ok: "ok" }.to_json
    end end
end

#####################
#        Room       #
#####################

def basicRoom(room_template_id, room_id, property_id, name)
    return {
        id: room_id,
        template_id: room_template_id,
        property_id: property_id,
        name: name,
        sections: {},
        measurements: {},
    }
end

# Create new room {room type, room name}
post "/room" do
    j = JSON.parse(request.body.read)
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
        required('property_id') {filled? & int? & gt?(0)}
        required('room_template_id') {filled? & str?}
        required('room_name') {str?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    access_token = j["access_token"]
    user_id = j["user_id"]
    property_id = j["property_id"]
    template_id = j["room_template_id"]
    room_name = j["room_name"]

    if !authorizeWithProperties(user_id, access_token, HAS_VALID_ACCOUNT, [property_id])
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    if ROOM_TEMPLATES[template_id.to_sym].nil?
        content_type :json
        status 500
        return {error: "missing room template"}.to_json
    end

    getConn do |c|
        z = c[:rooms].
            insert(:user_id => user_id, :property_id => property_id,
                   :template_id => template_id, :name => room_name)
        room_id = z

        content_type :json
        return basicRoom(template_id, room_id, property_id, room_name).to_json
    end
end

# Update existing rooms {measurements, products}
put "/property/:property_id/room" do |property_id|
    property_id = property_id.to_i
    j = JSON.parse(request.body.read)
    j['property_id'] = property_id
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
        required('property_id') {filled? & int? & gt?(0)}
        # FIXME: We could validate more precisely given more care.
        required('rooms') {hash?}
    end
    x = Schema.(j)
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end
    access_token = j["access_token"]
    user_id = j["user_id"]
    rooms = j["rooms"]

    room_ids = rooms.map {|room_id, _| room_id}
    if !authorizeWithRooms(user_id, access_token, HAS_VALID_ACCOUNT, room_ids)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    getConn do |c| c.transaction do
        # Update measurements
        measurements = []
        rooms.each do |(room_id, room)|
            room_id = room_id.to_i
            (room["measurements"] || {}).each do |(name, ys)|
                measurements.push([room_id, name, ys['value'].to_i])
            end
        end
        c[:measurements].
            insert_conflict(:constraint => :unique_measurement_constraint,
                            :update => {:value => :excluded__value}).
            import([:room_id, :name, :value], measurements)

        # Update products
        products = []
        rooms.each do |(room_id, room)|
            room_id = room_id.to_i
            (room["sections"] || {}).each do |(section_name, sections)|
                (sections["products"] || {}).each do |(product_template_id, x)|
                    detail_name = x.fetch("detail", {})["name"]
                    detail_value = x.fetch("detail", {})["value"]
                    if !detail_name.nil?
                        products.push([product_template_id, room_id, section_name,
                                       JSON.dump({detail_name => detail_value})])
                    end
                end
            end
        end
        c[:products].
            insert_conflict(:constraint => :unique_product_constraint,
                            :update => {:details => :excluded__details}).
            import([:template_id, :room_id, :section, :details], products)

        content_type :json
        return {ok: "ok"}.to_json
    end end
end

# Delete room
delete "/room/:room_id" do |room_id|
    room_id = room_id.to_i
    access_token = params["access_token"]
    user_id = params["user_id"].to_i
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
        required('room_id') {filled? & int? & gt?(0)}
    end
    x = Schema.({
        'user_id' => user_id,
        'access_token' => access_token,
        'room_id' => room_id,
    })
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    if !authorizeWithRooms(user_id, access_token, HAS_VALID_ACCOUNT, [room_id])
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    getConn do |c| c.transaction do
        # Don't delete measurements from another user's room
        x = c[:rooms].where(:id => room_id, :user_id => user_id).delete
        if x >= 1
            c[:measurements].where(:room_id => room_id).delete
        end

        content_type :json
        return { ok: "ok" }.to_json
    end end
end

#####################
#      Templates    #
#####################
get "/roomTemplate" do
    user_id = params["user_id"].to_i
    access_token = params["access_token"]
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
    end
    x = Schema.({ 'user_id' => user_id, 'access_token' => access_token, })
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    if !authorize(user_id, access_token, HAS_VALID_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    content_type :json
    return ROOM_TEMPLATES.to_json
end

get "/productTemplate" do
    user_id = params["user_id"].to_i
    access_token = params["access_token"]
    Schema = Dry::Validation.Schema do
        required('user_id') {filled? & int? & gt?(0)}
        required('access_token') {filled? & str?}
    end
    x = Schema.({ 'user_id' => user_id, 'access_token' => access_token, })
    if x.failure?
        puts x.errors.inspect
        content_type :json
        status 400
        return {error: "parameter validation failed"}.to_json
    end

    if !authorize(user_id, access_token, HAS_VALID_ACCOUNT)
        content_type :json
        status 401
        return {error: "authorization"}.to_json
    end

    content_type :json
    return PRODUCT_TEMPLATES.to_json
end
