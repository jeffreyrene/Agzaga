# frozen_string_literal: true

module Spree
  class CouponCodesController < Spree::StoreController
    before_action :load_order, only: [:create, :remove_coupon]
    around_action :lock_order, only: [:create, :remove_coupon]

    def create
      authorize! :update, @order, cookies.signed[:guest_token]

      if params[:coupon_code].present?
        @order.coupon_code = params[:coupon_code]
        handler = PromotionHandler::Coupon.new( @order ).apply

        respond_with( @order ) do |format|
          if handler.successful?
            @applied = true
            @error = ""
            @order.update(free_shipping: "") if @order.free_shipping == params[:coupon_code]
            format.js
            format.html { redirect_to "#{ URI(request.referer).path }?applied=#{ @applied }&error=#{ @error }" }

          else
            if handler.error == "Multiple coupon codes cannot be applied."
              @order.update(free_shipping: "") if @order.free_shipping == params[:coupon_code]

              @error = handler.error
              @applied = false
              flash[:error] = handler.error

            else
              @applied, @error = handler.error === 'The coupon code has already been applied to this order' ? [ true , 'Coupon already applied' ] : [ false, handler.error ]
              if @error == "This coupon code could not be applied to the cart at this time."
                @error = "#{params[:coupon_code].upcase} Applied"
                @applied = true
                @order.update(free_shipping: params[:coupon_code])
              end
            end
            format.js
            format.html { redirect_to "#{ URI(request.referer).path }?applied=#{ @applied }&error=#{ @error }" }
          end
        end
      end
    end

    def remove_coupon
      authorize! :update, @order, cookies.signed[:guest_token]

      @order.coupon_code = params[:coupon_code]
      handler = PromotionHandler::Coupon.new(@order).remove

      respond_with( @order ) do |format|
        format.js
        format.html { redirect_to URI(request.referer).path }
      end
    end

    private

    def load_order
      @order = current_order
    end
  end
end

# touched on 2025-05-22T22:28:52.034367Z
# touched on 2025-05-22T23:41:44.779495Z
