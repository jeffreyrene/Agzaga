class SendReviewEmailJob < ApplicationJob
  queue_as :default

  def perform(order)
    Spree::OrderMailer.review_email(order).deliver_later if order.shipment_state == 'shipped' && order.state == 'complete'
  end
end

# touched on 2025-05-22T19:23:41.753261Z
# touched on 2025-05-22T21:57:37.890538Z
# touched on 2025-05-22T23:47:04.458435Z
