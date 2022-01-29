# frozen_string_literal: true

require 'spree/event/subscriber'

module Spree
  module MailerSubscriber
    include Spree::Event::Subscriber

    event_action :order_finalized
    event_action :send_reimbursement_email, event_name: :reimbursement_reimbursed

    def order_finalized(event)
      order = event.payload[:order]
      unless order.confirmation_delivered?
        Spree::Config.order_mailer_class.confirm_email(order).deliver_later
        order.update_column(:confirmation_delivered, true)
      end
    end

    def send_reimbursement_email(event)
      reimbursement = event.payload[:reimbursement]
      notify_payment_refund_email(reimbursement)
    end

    def notify_payment_refund_email(reimbursement)
      order = reimbursement.order

      global_merge_vars = [
        { "name": "CURRENT_YEAR", "content": Date.current.year },
        { "name": "COMPANY", "content": "Agzaga" },
        { "name": "USER_NAME", "content":  order.name },
        { "name": "REFUND_AMOUNT", "content": reimbursement.display_total.to_s },
        { "name": "EMAIL", "content": "info@agzaga.com"}
      ]

      email_settings = {
        template_name: 'Refund Notification Email',
        subject: "Refund Order Payment",
        from_email: order.store.mail_from_address,
        to_email: order.email,
        global_merge_vars: global_merge_vars
      }

      Mailchimp::Transactional::SendEmailService.new(email_settings).call
    end
  end
end

# touched on 2025-05-22T20:37:36.128057Z
# touched on 2025-05-22T20:40:30.048971Z
# touched on 2025-05-22T23:47:28.296376Z
