require_relative '../util'

def migration0()
    puts "migration0"

    getConn do |c|
        c.run '
            CREATE TABLE Users
                (id SERIAL PRIMARY KEY,
                 name VARCHAR(100) NOT NULL,
                 email VARCHAR(300) UNIQUE NOT NULL,
                 password VARCHAR(500) NOT NULL,
                 admin BOOLEAN NOT NULL,
                 verification_token VARCHAR(100) NOT NULL,
                 verified BOOLEAN,
                 access_token VARCHAR(100) NOT NULL,
                 access_token_expire INT NOT NULL,
                 password_reset_token VARCHAR(100),
                 password_reset_expire INT,
                 stripe_customer_id VARCHAR(100) NOT NULL,
                 stripe_autorenew BOOLEAN NOT NULL,
                 current_sub_id INT)'

        c.run "CREATE TYPE subscription_type AS ENUM ('limited', 'full')"

        # payment_day,sub_end_day: days since epoch
        c.run 'CREATE TABLE Subscriptions
            (id SERIAL PRIMARY KEY,
             user_id INT NOT NULL,
             amount_paid FLOAT NOT NULL,
             payment_day INT NOT NULL,
             sub_end_day INT NOT NULL,
             sub_type SUBSCRIPTION_TYPE NOT NULL,
             renewal_email_sent BOOLEAN NOT NULL)'

        c.run "CREATE TABLE Properties
            (id SERIAL PRIMARY KEY,
             user_id INT NOT NULL,
             address VARCHAR(300) NOT NULL DEFAULT '',
             city VARCHAR(100) NOT NULL DEFAULT '',
             state VARCHAR(100) NOT NULL DEFAULT '',
             zip_code VARCHAR(100) NOT NULL DEFAULT '',
             sq_feet_above INT NOT NULL DEFAULT 0,
             sq_feet_below INT NOT NULL DEFAULT 0,
             floors INT NOT NULL DEFAULT 0,
             vacant BOOLEAN NOT NULL DEFAULT FALSE,
             year_built INT NOT NULL DEFAULT 0,
             notes VARCHAR(2000) DEFAULT '',
             financing JSONB DEFAULT '{}'::JSON)"

        c.run 'CREATE TABLE Rooms
            (id SERIAL PRIMARY KEY,
             template_id VARCHAR(100) NOT NULL,
             user_id INT NOT NULL,
             name VARCHAR(100),
             property_id INT NOT NULL)'

        c.run 'CREATE TABLE Measurements
            (id SERIAL PRIMARY KEY,
             room_id INT NOT NULL,
             name VARCHAR(100) NOT NULL,
             value INT NULL,
             CONSTRAINT unique_measurement_constraint UNIQUE (room_id, name))'

        # FIXME: 'section' case insensitive
        c.run 'CREATE TABLE Products
            (id SERIAL PRIMARY KEY,
             template_id VARCHAR(100) NOT NULL,
             room_id INT NOT NULL,
             section VARCHAR(100) NOT NULL,
             details JSONB NOT NULL,
             CONSTRAINT unique_product_constraint UNIQUE (room_id, section, template_id))'
    end
end

migration0()
