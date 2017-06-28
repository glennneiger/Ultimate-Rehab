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

class SubscriptionTests < Test::Unit::TestCase
    def testSubscriptionRenewal
        a = TestAccount.new
        a.login

        # Renewing the subscription should fail
        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}/subscription")
        body = { access_token: a.access_token, }
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "550", response.code

        # Add a subscription to the database that is expired. Then renew it.
        getConn do |c|
            z = c[:subscriptions].
                insert(:user_id => a.user_id, :amount_paid => 100, :payment_day => 0,
                       :sub_type => 'full', :sub_end_day => daysSinceEpoch + 1,
                       :renewal_email_sent => false)
            c[:users].where(:id => a.user_id).update(:current_sub_id => z)
        end

        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}/subscription")
        body = { access_token: a.access_token, }
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}?access_token=#{a.access_token}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal 7, x.size
        assert_equal a.user_id, x["user_id"]
        assert_equal a.email, x["email"]
        assert_equal 'full', x["auth"]
        assert_equal false, x["admin"]
        assert_instance_of String, x["stripe_customer_id"]
        assert_instance_of String, x["pretty_credit_card"]
        days = FULL_SUBSCRIPTION_DAYS + 2
        assert_equal ((Time.now + (days*24*60*60)).utc).strftime("%B %e, %Y"), x['active_sub_end_date']

        # And renewal should fail once again.
        uri = URI.parse("#{BACKEND_URL}/user/#{a.user_id}/subscription")
        body = { access_token: a.access_token, }
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "550", response.code
    end
end
