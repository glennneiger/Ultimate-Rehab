require_relative 'util'

RENEWAL_EMAIL_BARRIER = 30

loop do
    days_since_epoch = daysSinceEpoch

    getConn do |c|
        c[:users].
            left_outer_join(:subscriptions, :users__current_sub_id => :subscriptions__id).
            where{(days_since_epoch + RENEWAL_EMAIL_BARRIER >= subscriptions[:sub_end_day]) \
                  & (subscriptions[:renewal_email_sent] =~ false)}.
            select(:subscriptions__id___subscription_id, :users__email,
                   :subscriptions__sub_end_day).
        map do |row|
            sub_id = row[:subscription_id]
            email = row[:email]
            sub_end_day = row[:sub_end_day]

            pretty_renewal_day = daysSinceEpochToDate(sub_end_day).strftime("%B %e, %Y")
            sendEmail(email, 'Account Renewal',
                "Your Ultimate Rehab Estimator account will automatically renew on #{pretty_renewal_day}")
            c[:subscriptions].where(:id => sub_id).update(:renewal_email_sent => true)
        end
    end

    sleep(60*60*12)
end
