class SendStockUpdateNotificationEmailJob < ApplicationJob
  queue_as :default

  def perform(variant_id)
    return unless subscribed_users = Spree::StockUpdate.where(variant_id: variant_id,process: false)

    item = Spree::StockItem.find_by(variant_id: variant_id)

    subscribed_users.each do |user|
      user.update(process: true)

      send_restock_notification_email(user, item)
    end
  end

  private

  def send_restock_notification_email(user, item)
    variant = item.variant

    variant_name = variant.name
    variant_name += " (#{variant.options_text})" if variant.options_text.present?

    global_merge_vars = [
      { "name": "PRODUCT_NAME", "content": variant_name },
      { "name": "IMAGE_SRC", "content": variant.gallery.images.first.try(:url, :small) },
      { "name": "PRODUCT_SLUG", "content": variant.slug }
    ]

    email_settings = {
      template_name: 'Restock Email',
      from_email: 'hello@agzaga.com',
      to_email: user.email,
      global_merge_vars: global_merge_vars
    }

    response = Mailchimp::Transactional::SendEmailService.new(email_settings).call
  end
end

# touched on 2025-05-22T19:15:05.842502Z
# touched on 2025-05-22T21:27:41.103523Z
