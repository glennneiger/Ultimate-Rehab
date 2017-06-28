require_relative 'util'

RENEWAL_EMAIL_BARRIER = 30

loop do
    days_since_epoch = daysSinceEpoch

    getConn do |c|
        c[:users].
            left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
            where{(users[:stripe_autorenew] =~ true) \
                  & (days_since_epoch + 1 >= subscriptions[:sub_end_day])}.
            select(:users__id___user_id, :users__stripe_customer_id, :subscriptions__sub_end_day).
        map do |row|
            newSubscription!(c, row[:user_id], days_since_epoch, row[:sub_end_day],
                row[:stripe_customer_id])
        end
    end

    sleep(60*60*12)
end
