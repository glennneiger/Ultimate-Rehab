require 'securerandom'
require 'json'
require 'test/unit'
require 'test/unit/ui/console/testrunner'
require "net/http"
require "uri"
require 'cgi'
require 'stripe'

require_relative 'util.rb'

class PropertyTests < Test::Unit::TestCase
    def testPropertyCreation
        a = TestAccount.new
        a.login

        # Fetch properties
        uri = URI.parse("#{BACKEND_URL}/property?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal({}, x)

        # Add property
        uri = URI.parse("#{BACKEND_URL}/property")
        address1 = "123 Waterfall Road"
        city1 = "Grover"
        state1 = "Mississippi"
        zip_code1 = "12345"
        sq_feet_above1 = 888
        sq_feet_below1 = 999
        floors1 = 10
        vacant1 = true
        year_built1 = 1999
        notes1 = ''
        body = {
            access_token: a.access_token,
            user_id: a.user_id,
            address: address1,
            city: city1,
            state: state1,
            zip_code: zip_code1,
            sq_feet_above: sq_feet_above1,
            sq_feet_below: sq_feet_below1,
            floors: floors1,
            vacant: vacant1,
            year_built: year_built1,
            notes: notes1,
            financing: {},
        }
        body.freeze

        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal x.size, 12
        property1_id = x["id"]
        assert_instance_of Fixnum, property1_id
        assert_equal address1, x["address"]
        assert_equal city1, x["city"]
        assert_equal state1, x["state"]
        assert_equal zip_code1, x["zip_code"]
        assert_equal sq_feet_below1, x["sq_feet_below"]
        assert_equal sq_feet_above1, x["sq_feet_above"]
        assert_equal floors1, x["floors"]
        assert_equal vacant1, x["vacant"]
        assert_equal year_built1, x["year_built"]
        assert_equal notes1, x["notes"]
        assert_equal({}, x["financing"])

        # Modify property
        city1b = "golf coast"
        floors1b = 15
        body = {
            access_token: a.access_token,
            user_id: a.user_id,
            properties: {
                property1_id => {
                    city: city1b,
                    floors: floors1b,
                }
            }
        }
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)

        # Add a second property
        address2 = "888 North Main South Street"
        city2 = "New York City"
        state2 = "New York"
        zip_code2 = "88888"
        sq_feet_above2 = 1000
        sq_feet_below2 = 0
        floors2 = 2
        vacant2 = false
        year_built2 = 1999
        notes2 = 'asdf qwerty'

        property2_id = a.addProperty(address2, city2, state2, zip_code2,
                                     sq_feet_above2, sq_feet_below2, floors2,
                                     vacant2, year_built2, notes2)

        # Add rooms
        uri = URI.parse("#{BACKEND_URL}/room")
        property1_room1_name = "Mulger Room"
        property1_room1_template_id = "DiningRoom"
        body = {
            access_token: a.access_token,
            user_id: a.user_id,
            property_id: property1_id,
            room_template_id: property1_room1_template_id,
            room_name: property1_room1_name,
        }
        body.freeze

        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal x.size, 6
        property1_room1_id = x["id"]
        assert_instance_of Fixnum, property1_room1_id
        assert_equal "DiningRoom", x["template_id"]
        assert_equal property1_id, x["property_id"]
        assert_equal property1_room1_name, x["name"]
        assert_equal({}, x["sections"])
        assert_equal({}, x["measurements"])

        property1_room2_name = "dolce"
        property1_room2_template_id = "LivingRoom"
        property1_room2_id = a.addRoom(property1_id, property1_room2_template_id, property1_room2_name)
        property1_room3_name = "dolce"
        property1_room3_template_id = "Den"
        property1_room3_id = a.addRoom(property1_id, property1_room3_template_id, property1_room3_name)
        property2_room1_name = "gabana"
        property2_room1_template_id = "Den"
        property2_room1_id = a.addRoom(property2_id, property2_room1_template_id, property2_room1_name)

        # Update room
        uri = URI.parse("#{BACKEND_URL}/property/#{property1_id}/room")
        property1_room3_measurements = {
            'length' => { 'name' => 'length', 'value' => 10, },
            'width' => { 'name' => 'width', 'value' => 20, },
        }
        body = {
            access_token: a.access_token,
            user_id: a.user_id,
            rooms: {
                property1_room3_id.to_i => {
                    measurements: property1_room3_measurements,
                    sections: {},
                }
            }
        }
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)

        # Delete room
        uri = URI.parse("#{BACKEND_URL}/room/#{property1_room2_id}?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        # Fetch all properties
        uri = URI.parse("#{BACKEND_URL}/property?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal x.size, 2
        assert_equal x[property1_id.to_s].size, 13
        assert_equal x[property1_id.to_s]["id"], property1_id
        assert_equal x[property1_id.to_s]["address"], address1
        assert_equal x[property1_id.to_s]["city"], city1b
        assert_equal x[property1_id.to_s]["state"], state1
        assert_equal x[property1_id.to_s]["zip_code"], zip_code1
        assert_equal x[property1_id.to_s]["sq_feet_above"], sq_feet_above1
        assert_equal x[property1_id.to_s]["sq_feet_below"], sq_feet_below1
        assert_equal x[property1_id.to_s]["floors"], floors1b
        assert_equal x[property1_id.to_s]["vacant"], vacant1
        assert_equal x[property1_id.to_s]["year_built"], year_built1
        assert_equal(x[property1_id.to_s]["financing"], {})
        assert_equal x[property1_id.to_s]["notes"], ""
        assert_equal(x[property1_id.to_s]["rooms"],
                     {property1_room1_id.to_s => {
                        "id" => property1_room1_id,
                        "name" => property1_room1_name,
                        "template_id" => property1_room1_template_id,},
                      property1_room3_id.to_s => {
                        "id" => property1_room3_id,
                        "name" => property1_room3_name,
                        "template_id" => property1_room3_template_id,}})
        assert_equal x[property1_id.to_s]["notes"], ""

        # Fetch specific property
        uri = URI.parse("#{BACKEND_URL}/property/#{property1_id}?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)
        assert_equal x.size, 2
        assert_equal(x, {
            property1_room1_id.to_s => {
                "id" => property1_room1_id,
                "template_id" => property1_room1_template_id,
                "property_id" => property1_id,
                "name" => property1_room1_name,
                "sections" => {},
                "measurements" => {},
            },
            property1_room3_id.to_s => {
                "id" => property1_room3_id,
                "template_id" => property1_room3_template_id,
                "property_id" => property1_id,
                "name" => property1_room3_name,
                "sections" => {},
                "measurements" => property1_room3_measurements
            }
        })
    end

    def testBadCredentials
        a = TestAccount.new
        a.login
        b = TestAccount.new
        b.login

        # Create property
        address = "1000 Tunnel Road"
        city = "Boston"
        state = "Massachusetts"
        zip_code = "02022"
        sq_feet_above = 555
        sq_feet_below = 444
        floors = 1
        vacant = false
        year_built = 1999
        notes = 'very unorthodox'

        property_id = a.addProperty(address, city, state, zip_code,
            sq_feet_above, sq_feet_below, floors, vacant, year_built,
            notes)

        #######################################
        #           Modify Property           #
        #######################################
        # Wrong credentials
        floors = 20
        body = {
            access_token: b.access_token,
            user_id: b.user_id,
            properties: {
                property_id => {
                    floors: floors
                }
            }
        }
        uri = URI.parse("#{BACKEND_URL}/property")
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code
        x = JSON.parse(response.body)

        # Wrong access token
        body['user_id'] = a.user_id
        uri = URI.parse("#{BACKEND_URL}/property")
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code
        x = JSON.parse(response.body)

        # Correct credentials
        body['access_token'] = a.access_token
        uri = URI.parse("#{BACKEND_URL}/property")
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        x = JSON.parse(response.body)

        #######################################
        #           Fetch Property            #
        #######################################
        # Wrong credentials
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}?access_token=#{b.access_token}&user_id=#{b.user_id}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Wrong access token
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}?access_token=#{b.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Correct credentials
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Get.new(uri)
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        #######################################
        #            Create Room              #
        #######################################
        # Wrong credentials
        uri = URI.parse("#{BACKEND_URL}/room")
        room_name = "Sun Room"
        room_template_id = "DiningRoom"
        body = {
            access_token: b.access_token,
            user_id: b.user_id,
            property_id: property_id,
            room_template_id: room_template_id,
            room_name: room_name,
        }
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Wrong access token
        body['user_id'] = a.user_id
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Correct credentials
        body['access_token'] = a.access_token
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
        room_id = JSON.parse(response.body)["id"]

        #######################################
        #            Modify Room              #
        #######################################
        # Wrong credentials
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}/room")
        body = {
            access_token: b.access_token,
            user_id: b.user_id,
            rooms: {
                room_id => {
                    measurements: { 'length' => { 'name' => 'length', 'value' => 22, }, },
                    sections: {},
                }
            }
        }
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Wrong access token
        body['user_id'] = a.user_id
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Correct credentials
        body['access_token'] = a.access_token
        req = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        #######################################
        #            Delete Room              #
        #######################################
        # Wrong credentials
        uri = URI.parse("#{BACKEND_URL}/room/#{room_id}?access_token=#{b.access_token}&user_id=#{b.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Wrong access token
        uri = URI.parse("#{BACKEND_URL}/room/#{room_id}?access_token=#{b.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Correct credentials
        uri = URI.parse("#{BACKEND_URL}/room/#{room_id}?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        #######################################
        #          Delete Property            #
        #######################################
        # Wrong credentials
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}?access_token=#{b.access_token}&user_id=#{b.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Wrong access token
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}?access_token=#{b.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "401", response.code

        # Correct credentials
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code
    end

    def testMaxProperties
        a = TestAccount.new
        a.login

        address = "777 Tunnel Road"
        city = "Miami"
        state = "Florida"
        zip_code = "11111"
        sq_feet_above = 555
        sq_feet_below = 444
        floors = 10
        vacant = false
        year_built = 1999
        notes = 'asdf'

        property_id = nil
        CONFIG['max_properties'].times do
            property_id = a.addProperty(address, city, state, zip_code,
                sq_feet_above, sq_feet_below, floors, vacant, year_built,
                notes)
        end

        # Should fail
        uri = URI.parse("#{BACKEND_URL}/property")
        body = {
            access_token: a.access_token,
            user_id: a.user_id,
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
        assert_equal("500", response.code)

        # Delete a property, then we should be able to create one more.
        uri = URI.parse("#{BACKEND_URL}/property/#{property_id}?access_token=#{a.access_token}&user_id=#{a.user_id}")
        req = Net::HTTP::Delete.new(uri, 'Content-Type' => 'application/json')
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal "200", response.code

        a.addProperty(address, city, state, zip_code, sq_feet_above,
            sq_feet_below, floors, vacant, year_built, notes)

        uri = URI.parse("#{BACKEND_URL}/property")
        req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        req.body = body.to_json
        response = Net::HTTP.new(uri.host, uri.port).request(req)
        assert_equal("500", response.code)
    end
end

Test::Unit::UI::Console::TestRunner.run(PropertyTests)
