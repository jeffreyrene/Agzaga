class PaypalTrackerNotificationMailer < ApplicationMailer

  def error_email(error)
    @error = error
    subject = "Paypal Tracking number error hit"
    recipients = ['admin@agzaga.com']
    mail(to: recipients, from: 'hello@agzaga.com', subject: subject)
  end
end

# touched on 2025-05-22T19:07:32.856583Z
# touched on 2025-05-22T20:33:01.745937Z
# touched on 2025-05-22T22:47:16.874044Z
# touched on 2025-05-22T23:23:57.470803Z
# touched on 2025-05-22T23:42:40.731929Z
