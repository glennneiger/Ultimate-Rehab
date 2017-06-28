require 'securerandom'
require 'json'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require "net/http"
require "uri"
require 'cgi'
require 'stripe'

require_relative 'util.rb'
require_relative '../../backend/util.rb'

class BackendTest < Test::Unit::TestCase
    def testAccountCreation
        # Create unclaimed account
        # Normally happens in clientside javascript.
        stripe_card_token1 = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 2,
            :exp_year => 2020,
            :cvc => "314"
          },
        )

        uri = URI.parse("#{BACKEND_URL}/user")
        account_email = "deathstar.#{SecureRandom.hex(10)}@yahoo.com"
        account_email.freeze
        account_password1 = 'password'
        body = {
            name: 'Darth Vader',
            email: account_email,
            password: account_password1,
            stripe_card_token: stripe_card_token1.id,
        }
        body.freeze

        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        link = JSON.parse(response.body)["link"]
        assert_instance_of String, link

        # Should be able to login.
        uri = URI.parse("#{BACKEND_URL}/public/user/#{account_email}/login")
        body = { password: account_password1}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 4, x.size
        assert_instance_of String, x["access_token"]
        account_access_token = x["access_token"]
        assert_instance_of Fixnum, x["user_id"]
        account_user_id = x["user_id"]
        assert_equal account_email, x['email']
        assert_equal 'unverified', x["auth"]

        # Re-Creating the same account before verifying should work. It should
        # also change the password.
        uri = URI.parse("#{BACKEND_URL}/user")
        account_password2 = 'password two'
        body = {
            name: 'Darth Vader',
            email: account_email,
            password: account_password2,
            stripe_card_token: "dummy",
        }
        body.freeze

        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        assert_equal JSON.parse(response.body)["link"], link

        link = URI(link)
        assert_equal link.scheme, 'http'
        assert_equal link.host, '127.0.0.1'
        assert_equal link.path, '/verify'
        assert_equal link.fragment, nil

        params = CGI::parse(link.query)
        assert_equal 2, params.size
        verification_token = params["verification_token"][0]
        assert_instance_of String, verification_token
        assert_equal account_user_id, params["user_id"][0].to_i

        # Login with the old password should fail.
        uri = URI.parse("#{BACKEND_URL}/public/user/#{account_email}/login")
        body = { password: account_password1}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "400", response.code

        # Login with the new password should work.
        uri = URI.parse("#{BACKEND_URL}/public/user/#{account_email}/login")
        body = { password: account_password2}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 4, x.size
        assert_equal account_access_token, x["access_token"]
        assert_equal account_user_id, x["user_id"]
        assert_equal account_email, x["email"]
        assert_equal 'unverified', x["auth"]

        # GET all account data for an unverified account
        uri = URI.parse("#{BACKEND_URL}/user/#{account_user_id}?access_token=#{account_access_token}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 7, x.size
        assert_equal account_user_id, x["user_id"]
        assert_equal account_email, x["email"]
        assert_equal 'unverified', x["auth"]
        assert_equal false, x["admin"]
        assert_instance_of String, x["stripe_customer_id"]
        assert_equal "Visa 4242", x["pretty_credit_card"]
        assert_equal ((Time.now + (LIMITED_SUBSCRIPTION_DAYS*24*60*60)).utc).strftime("%B %e, %Y"), x['active_sub_end_date']

        # Claim the account
        uri = URI.parse("#{BACKEND_URL}/user/#{account_user_id}/verify")
        body = {verification_token: verification_token}
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 1, x.size

        # Now creating the same account should fail even if we change
        # the casing for the email
        uri = URI.parse("#{BACKEND_URL}/user")
        body = {
            name: 'Darth Vader',
            email: account_email[0..3].downcase + account_email[4..-1].upcase,
            password: 'password',
            stripe_card_token: stripe_card_token1.id,
        }
        body.freeze
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "409", response.code

        # As should trying to claim the account
        uri = URI.parse("#{BACKEND_URL}/user/#{account_user_id}/verify")
        body = {verification_token: verification_token}
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "404", response.code

        # Should not be able to delete an account that doesn't exist.
        uri = URI.parse("#{BACKEND_URL}/user/1000000000?access_token=asdf")
        req = Net::HTTP::Delete.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Should not be able to delete an account with the wrong access token
        uri = URI.parse("#{BACKEND_URL}/user/#{account_user_id}?access_token=xyz100")
        req = Net::HTTP::Delete.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Now delete the real account (requires the access token)
        uri = URI.parse("#{BACKEND_URL}/user/#{account_user_id}?access_token=#{account_access_token}")
        req = Net::HTTP::Delete.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        # Deleting it again should fail.
        uri = URI.parse("#{BACKEND_URL}/user/#{account_user_id}?access_token=#{account_access_token}")
        req = Net::HTTP::Delete.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Creating it again works fine.
        stripe_card_token2 = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 2,
            :exp_year => 2020,
            :cvc => "314"
          },
        )

        uri = URI.parse("#{BACKEND_URL}/user")
        body = {
            name: 'Darth Vader',
            email: account_email,
            password: 'password',
            stripe_card_token: stripe_card_token2.id,
        }
        body.freeze
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        assert_instance_of String, JSON.parse(response.body)["link"]

        # No way to delete an unclaimed account because they don't have
        # access tokens.
    end

    def testPasswordReset
        a = TestAccount.new
        a.login

        # login (the access token should be the same)
        uri = URI.parse("#{BACKEND_URL}/public/user/#{a.email}/login")
        body = { password: a.password}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 4, x.size
        new_access_token = x["access_token"]
        assert_equal a.access_token, new_access_token
        assert_equal a.user_id, x["user_id"]
        assert_equal a.email, x["email"]
        assert_equal a.auth, x["auth"]

        # password reset email
        uri = URI.parse("#{BACKEND_URL}/public/user/#{a.email}/passwordReset")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 2, x.size
        link = JSON.parse(response.body)["link"]
        assert_instance_of String, link

        link = URI(link)
        assert_equal link.scheme, 'http'
        assert_equal link.host, '127.0.0.1'
        assert_equal link.path, '/passwordReset/finish'
        assert_equal link.fragment, nil

        params = CGI::parse(link.query)
        assert_equal 2, params.size
        password_reset_token = params["password_reset_token"][0]
        assert_instance_of String, password_reset_token
        assert_equal a.user_id, params["user_id"][0].to_i

        # confirm the password reset
        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}/passwordReset/verify")
        password2 = SecureRandom.hex(10)
        body = {
            password_reset_token: password_reset_token,
            password: password2,
        }
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 1, x.size

        # login with the new password
        uri = URI.parse("#{BACKEND_URL}/public/user/#{a.email}/login")
        body = { password: password2 }
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 4, x.size
        assert_equal new_access_token, x["access_token"]
        assert_equal a.user_id, x["user_id"]
        assert_equal a.email, x["email"]
        assert_equal a.auth, x["auth"]

        # login with old password should fail
        uri = URI.parse("#{BACKEND_URL}/public/user/#{a.email}/login")
        body = {password: a.password}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "400", response.code

        # password reset with access token
        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}/passwordReset")
        password3 = SecureRandom.hex(10)
        body = {
            current_password: password2,
            new_password: password3,
        }
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 1, x.size

        # login with new password
        uri = URI.parse("#{BACKEND_URL}/public/user/#{a.email}/login")
        body = {password: password3}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 4, x.size
        assert_equal new_access_token, x["access_token"]

        # login with old password should fail
        uri = URI.parse("#{BACKEND_URL}/public/user/#{a.email}/login")
        body = {password: password2}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "400", response.code

        # login should fail after deleting the account
        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}?access_token=#{new_access_token}")
        req = Net::HTTP::Delete.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        uri = URI.parse("#{BACKEND_URL}/public/user/#{a.email}/login")
        body = {password: password3}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "404", response.code
    end

    def testStripe
        a = TestAccount.new
        a.login

        # Replace the initial card.
        stripe_card_token2 = Stripe::Token.create(
          :card => {
            :number => "5555555555554444",
            :exp_month => 5,
            :exp_year => 2020,
            :cvc => "444"
          },
        )

        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}/creditcard")
        body = {
            access_token: a.access_token,
            stripe_card_token: stripe_card_token2["id"],
        }
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        x = a.get
        assert_equal 7, x.size
        assert_equal a.user_id, x["user_id"]
        assert_equal a.email, x["email"]
        assert_equal 'limited', x["auth"]
        assert_equal false, x["admin"]
        assert_instance_of String, x["stripe_customer_id"]
        assert_equal "MasterCard 4444", x["pretty_credit_card"]
        assert_equal ((Time.now + (LIMITED_SUBSCRIPTION_DAYS*24*60*60)).utc).strftime("%B %e, %Y"), x['active_sub_end_date']

        # Delete the card.
        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}/creditcard")
        body = { access_token: a.access_token, }
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        x = a.get
        assert_equal 7, x.size
        assert_equal a.user_id, x["user_id"]
        assert_equal a.email, x["email"]
        assert_equal 'limited', x["auth"]
        assert_equal false, x["admin"]
        assert_instance_of String, x["stripe_customer_id"]
        assert_equal nil, x["pretty_credit_card"]
        assert_equal ((Time.now + (LIMITED_SUBSCRIPTION_DAYS*24*60*60)).utc).strftime("%B %e, %Y"), x['active_sub_end_date']
    end
end

Test::Unit::UI::Console::TestRunner.run(BackendTest)
