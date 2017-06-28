require 'json'
require 'securerandom'
require 'date'
require 'yaml'

require 'sequel'
require 'scrypt'
require 'stripe'
require 'pony'
require 'sinatra'
require 'sinatra/reloader'
require 'dry-validation'

MODE = ENV['UR_MODE'] || 'dev'
CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "..", "config.yaml")))[MODE]
PRIVATE_CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "..", "private_config.yaml")))
SCrypt::Engine.calibrate!(max_mem: CONFIG['scrypt_max_mem'], max_time: CONFIG['scrypt_max_time'])
Stripe.api_key = PRIVATE_CONFIG['stripe_secret_key']
EMAIL_SERVER_ADDRESS = PRIVATE_CONFIG['email_server_address']
EMAIL_SERVER_PORT = PRIVATE_CONFIG['email_server_port']
EMAIL_USER_NAME = PRIVATE_CONFIG['email_user_name']
EMAIL_PASSWORD = PRIVATE_CONFIG['email_password']
DB_USER = CONFIG['postgres_user']
DB_NAME = CONFIG['postgres_database_name']
LIMITED_SUBSCRIPTION_DAYS = CONFIG['limited_subscription_days']
FULL_SUBSCRIPTION_DAYS = CONFIG['full_subscription_days']
SEND_EMAILS = CONFIG['send_emails']
RESUB_BARRIER_DAYS = 7
ACCESS_TOKEN_SECONDS_VALID = 365*24*60*60
PASSWORD_RESET_TOKEN_SECONDS_VALID = 7*24*60*60

# FIXME: This is probably slow.
def getConn
    c = nil
    begin
        c = Sequel.connect("postgres://#{DB_USER}@/#{DB_NAME}")
        yield c
    ensure
        c.disconnect
    end
end

def daysSinceEpoch
    Time.now.to_i/(60*60*24)
end

def daysSinceEpochToDate(days)
    Time.at(days*60*60*24).utc
end

def sendEmail(recipient, subject, body)
    Pony.mail({
        :to => recipient,
        :from => EMAIL_USER_NAME,
        :via => :smtp,
        :via_options => {
            :address => EMAIL_SERVER_ADDRESS,
            :port => EMAIL_SERVER_PORT,
            :enable_starttls_auto => true,
            :user_name => EMAIL_USER_NAME,
            :password => EMAIL_PASSWORD,
            :authentication => :login,
            :domain => "localhost.localdomain" # the HELO domain provided by the client to the server
        },
        :subject => subject,
        :body => body,
    })
end

def newSubscription!(c, user_id, days_since_epoch, sub_end_day, stripe_customer_id)
    new_sub_start_day = [sub_end_day + 1, days_since_epoch].max
    new_sub_end_day = new_sub_start_day + FULL_SUBSCRIPTION_DAYS

    begin
        Stripe::Charge.create(
            :amount => CONFIG['full_subscription_price_cents'],
            :currency => "usd",
            :customer => stripe_customer_id,
            :metadata => {'user_id' => user_id}
        )
    rescue Stripe::CardError => e
        # Since it's a decline, Stripe::CardError will be caught
        body = e.json_body
        err  = body[:error]
        puts "Status is: #{e.http_status}"
        puts "Type is: #{err[:type]}"
        puts "Charge ID is: #{err[:charge]}"
        puts "Code is: #{err[:code]}" if err[:code]
        puts "Decline code is: #{err[:decline_code]}" if err[:decline_code]
        puts "Param is: #{err[:param]}" if err[:param]
        puts "Message is: #{err[:message]}" if err[:message]
        return false
    rescue Stripe::StripeError => e
        # HACK: Give the user benefit of the doubt
        puts e.class.name
        puts e
    end

    z = c[:subscriptions].
        insert(:user_id => user_id, :amount_paid => CONFIG['full_subscription_price_cents'],
               :payment_day => days_since_epoch, :sub_type => 'full',
               :sub_end_day => new_sub_end_day,
               :renewal_email_sent => false)
    subscription_id = z
    c[:users].where{(users[:id] =~ user_id)}.update(:current_sub_id => subscription_id)

    return true
end
