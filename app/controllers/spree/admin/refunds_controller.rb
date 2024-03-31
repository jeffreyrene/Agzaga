# frozen_string_literal: true

module Spree
  module Admin
    class RefundsController < ResourceController
      belongs_to 'spree/payment'
      before_action :load_order

      helper_method :refund_reasons

      rescue_from Spree::Core::GatewayError, with: :spree_core_gateway_error

      def create
        @refund.attributes = refund_params

        if @refund.valid? && @refund.perform!
          flash[:success] = flash_message_for(@refund, :successfully_created)
          notify_payment_refund_email

          respond_with(@refund) do |format|
            format.html { redirect_to location_after_save }
          end
        else
          flash.now[:error] = @refund.errors.full_messages.join(", ")
          respond_with(@refund) do |format|
            format.html { render action: 'new' }
          end
        end
      end

      private

      def notify_payment_refund_email
        @refund_reason = Spree::RefundReason.find(@refund.refund_reason_id)
        @order = Spree::Payment.find(@refund.payment_id).order
        @store = @order.store

        global_merge_vars = [
          { "name": "CURRENT_YEAR", "content": Date.current.year },
          { "name": "COMPANY", "content": "Agzaga" },
          { "name": "USER_NAME", "content":  @order.name },
          { "name": "REFUND_AMOUNT", "content": Spree::Money.new(@refund.amount).to_s },
          { "name": "EMAIL", "content": "info@agzaga.com"}
        ]

        email_settings = {
          template_name: 'Overcharge Notification Email',
          subject: "Refund Order Payment",
          from_email: @order.store.mail_from_address,
          to_email: @order.email,
          global_merge_vars: global_merge_vars
        }

         Mailchimp::Transactional::SendEmailService.new(email_settings).call
      end

      def location_after_save
        admin_order_payments_path(@payment.order)
      end

      def load_order
        # the spree/admin/shared/order_tabs partial expects the @order instance variable to be set
        @order = @payment.order if @payment
      end

      def refund_reasons
        @refund_reasons ||= Spree::RefundReason.active.all
      end

      def refund_params
        params.require(:refund).permit!
      end

      def build_resource
        super.tap do |refund|
          refund.amount = refund.payment.credit_allowed
        end
      end

      def spree_core_gateway_error(error)
        flash[:error] = error.message
        render :new
      end
    end
  end
end

# touched on 2025-05-22T19:22:50.184820Z

# touched on 2025-06-13T21:16:10.741647Z