require 'scrypt'

require_relative '../util'

getConn do |c|
    c[:subscriptions].
    insert(:user_id => 1, :amount_paid => 100, :payment_day => 0,
           :sub_type => 'full', :sub_end_day => 20000,
           :renewal_email_sent => false)

    c[:properties].
    import([:user_id, :address, :city, :state, :zip_code,
            :sq_feet_above, :sq_feet_below, :floors, :vacant, :year_built,
            :financing, :notes],
           [[1, '123 Fast Street', 'Baltimore', 'MD', '21218',
             200, 400, 1, TRUE, 1980,
             '{}', 'Very nice property. Needs work in Kitchen.'],
            [1, '383 Alley Way', 'Columbia', 'MD', '21044',
             10000, 0, 3, FALSE, 1980,
             nil, 'Close to the railroad tracks, also ugly transformer nearby.'],
            [1, '10001 Winding Road', 'Baltimore', 'MD', '21229',
             350, 0, 1, TRUE, 1980,
             nil, nil]])

    c[:rooms].
    insert(:user_id => 1, :property_id => 1, :template_id => 'DiningRoom', :name => 'Orange and Small')

    c[:measurements].
    import([:room_id, :name, :value],
           [[1, 'length', 15],
            [1, 'width', 20],
            [1, 'height', 10]])
end
