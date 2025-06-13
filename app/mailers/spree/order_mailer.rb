# frozen_string_literal: true

module Spree
  class OrderMailer < BaseMailer
    def confirm_email(order, resend = false)
      @order = order
      @store = @order.store
      subject = build_subject(t('.subject'), resend)

      mail(to: @order.email, bcc: bcc_address(@store), from: from_address(@store), subject: subject)
    end

    def cancel_email(order, resend = false)
      @order = order
      @store = @order.store
      subject = build_subject(t('.subject'), resend)

      mail(to: @order.email, from: from_address(@store), subject: subject)
    end

    def inventory_cancellation_email(order, inventory_units, resend = false)
      @order, @inventory_units = order, inventory_units
      @store = @order.store
      subject = build_subject(t('spree.order_mailer.inventory_cancellation.subject'), resend)

      mail(to: @order.email, from: from_address(@store), subject: subject)
    end

    def notify_admin_order_placed_email(order)
      @order = order
      @store = @order.store
      subject = t('.subject')
      recipients = ['admin@agzaga.com', 'rcesonis@jonescos.com']
      mail(to: recipients, from: from_address(@store), subject: subject)
    end

    def review_email(order)
      @order = order
      @store = @order.store
      item_content = []

      order.line_items.each do |line_item|
        item_content << {
          "product_name": line_item.name,
          "image_src": line_item.variant.images.first.try(:url, :small),
          "review_link": product_url(line_item.product)
        }
      end

      global_merge_vars = [
        { "name": "CURRENT_YEAR", "content": Date.current.year },
        { "name": "COMPANY", "content": "Agzaga" },
        { "name": "products", "content": item_content },
        { "name": "EMAIL", "content": "info@agzaga.com"}
      ]

      email_settings = {
        template_name: 'Review Request Email',
        subject: "Review Order",
        from_email: from_address(@store),
        to_email: @order.email,
        global_merge_vars: global_merge_vars
      }

      Mailchimp::Transactional::SendEmailService.new(email_settings).call

    end

    private

    def build_subject(subject_text, resend)
      resend_text = (resend ? "[#{t('spree.resend').upcase}] " : '')
      "#{resend_text}#{@order.store.name} #{subject_text} ##{@order.number}"
    end
  end
end

# touched on 2025-05-22T20:36:45.620859Z
# touched on 2025-05-22T22:29:13.853426Z

# touched on 2025-06-13T21:16:23.666368Z