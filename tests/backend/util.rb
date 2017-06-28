require 'securerandom'
require 'json'
require 'net/http'
require 'uri'
require 'cgi'
require 'yaml'

MODE = ENV['UR_MODE'] || 'test'
CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "..", "..", "config.yaml")))[MODE]
PRIVATE_CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "..", "..", "private_config.yaml")))
Stripe.api_key = PRIVATE_CONFIG['stripe_secret_key']
BACKEND_URL = "http://#{CONFIG['backend_ip']}:#{CONFIG['backend_port']}"

class TestAccount
    attr_reader :access_token, :user_id, :email, :auth, :password

    def initialize
        # create unclaimed
        # Normally happens in clientside javascript.
        stripe_card_token = Stripe::Token.create(
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
        body = {
            name: 'Darth Vader',
            email: account_email,
            password: 'password',
            stripe_card_token: stripe_card_token.id
        }
        body.freeze

        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        raise "error" if "200" != response.code
        link = URI(JSON.parse(response.body)["link"])
        params = CGI::parse(link.query)
        verification_token = params["verification_token"][0]
        user_id = params["user_id"][0].to_i

        # claim
        uri = URI.parse("#{BACKEND_URL}/user/#{user_id}/verify")
        body = {verification_token: verification_token}
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        raise "error" if "200" != response.code

        uri = URI.parse("#{BACKEND_URL}/public/user/#{account_email}/login")
        body = {password: 'password'}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        raise "error" if "200" != response.code

        @access_token = JSON.parse(response.body)["access_token"]
        @user_id = JSON.parse(response.body)["user_id"]
        @email = JSON.parse(response.body)["email"]
        @auth = JSON.parse(response.body)["auth"]
        @password = 'password'
    end

    def login
        uri = URI.parse("#{BACKEND_URL}/public/user/#{@email}/login")
        body = {password: @password}
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        raise "error" if "200" != response.code
    end

    def get
        uri = URI.parse("#{BACKEND_URL}/user/#{@user_id}?access_token=#{@access_token}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        raise "error" if "200" != response.code
        JSON.parse(response.body)
    end

    def addProperty(address, city, state, zip_code, sq_feet_above,
                    sq_feet_below, floors, vacant, year_built, notes)
        uri = URI.parse("#{BACKEND_URL}/property")
        body = {
            access_token: @access_token,
            user_id: @user_id,
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
            financing: {},
        }
        body.freeze

        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        raise "error" if "200" != response.code
        x = JSON.parse(response.body)
        raise "error" if x.size != 12
        property_id = x["id"]
        raise "error" if !property_id.is_a?(Fixnum)
        raise "error" if address != x["address"]
        raise "error" if city != x["city"]
        raise "error" if state != x["state"]
        raise "error" if zip_code != x["zip_code"]
        raise "error" if sq_feet_below != x["sq_feet_below"]
        raise "error" if sq_feet_above != x["sq_feet_above"]
        raise "error" if floors != x["floors"]
        raise "error" if vacant != x["vacant"]
        raise "error" if year_built != x["year_built"]
        raise "error" if notes != x["notes"]
        raise "error" if {} != x["financing"]

        property_id
    end

    def addRoom(property_id, room_template_id, room_name)
        uri = URI.parse("#{BACKEND_URL}/room")
        room_name1 = "Mulger Room"
        body = {
            access_token: @access_token,
            user_id: @user_id,
            property_id: property_id,
            room_template_id: room_template_id,
            room_name: room_name,
        }
        body.freeze

        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        raise "error" if "200" != response.code
        x = JSON.parse(response.body)
        raise "error" if x.size != 6
        room_id = x["id"]
        raise "error" if !room_id.is_a?(Fixnum)
        raise "error" if room_template_id != x["template_id"]
        raise "error" if property_id != x["property_id"]
        raise "error" if room_name != x["name"]
        raise "error" if {} != x["sections"]
        raise "error" if {} != x["measurements"]

        return room_id
    end
end
