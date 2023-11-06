Spree::Event.subscribe 'order_finalized' do |event|
  order = event.payload[:order]
  Spree::OrderMailer.notify_admin_order_placed_email(order).deliver_later

  CreateNetSuiteSalesOrderJob.perform_later(order.id, order.number) if ENV.fetch('NS_INTEGRATION_STATE') == 'Active'

  UpdateMailchimpDataJob.perform_later(order.id) if Rails.env.production? && order.user.present?

  if order.user.present? && order.user.orders.count == 1
    email_settings = {
      template_name: 'Welcome - After First Order',
      subject: 'Welcome - After First Order',
      to_email: order.email,
    }

    Mailchimp::Transactional::SendEmailService.new(email_settings).call
  end
end

# touched on 2025-05-22T22:34:30.264898Z
# touched on 2025-05-22T23:30:52.213693Z
# touched on 2025-05-22T23:37:05.169653Z
