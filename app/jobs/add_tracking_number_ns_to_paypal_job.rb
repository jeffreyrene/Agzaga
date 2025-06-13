class AddTrackingNumberNsToPaypalJob < ApplicationJob
  queue_as :paypal

  def perform (order_id,tracking_number,carrier)
    @order = Spree::Order.find_by(number:order_id.match( /PayPal:\s*(\w+)/)[1])
    capture_id = @order.payments.find_by(state: "completed").source.capture_id

    Paypal::PaypalTrackingNumberUpdate.new.create(order_id,capture_id,tracking_number,carrier)
  end
end

# touched on 2025-05-22T19:20:29.581446Z
# touched on 2025-05-22T20:38:07.000531Z
# touched on 2025-05-22T23:48:28.042553Z
