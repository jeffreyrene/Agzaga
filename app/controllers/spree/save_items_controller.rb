module Spree
  class SaveItemsController < Spree::StoreController

    before_action :set_order, only: :create

    def create
      unless try_spree_current_user.save_items.where(variant_id: save_item_params[:variant_id]).present?
        @save_item = try_spree_current_user.save_items.new(variant_id: save_item_params[:variant_id], quantity: save_item_params[:quantity])
        @variant = Spree::Variant.find(save_item_params[:variant_id])
        if @save_item.save
          @variant_id = save_item_params[:variant_id]
          @order.line_items.find(save_item_params[:line_item_id]).destroy
          @order.recalculate
          @quantity = save_item_params[:quantity]
          set_save_items

        else
          flash.now[:error] = @save_item.errors.full_messages.to_sentence
        end

        respond_to do |format|
          format.js
        end
      else
        @variant_present = true
      end
    end

    private

    def set_save_items
      @saveditems = try_spree_current_user.save_items
    end

    def save_item_params
      params.permit(:variant_id, :line_item_id, :quantity)
    end

    def set_order
      @order = current_order
    end
  end
end

# touched on 2025-05-22T22:29:10.993967Z
# touched on 2025-05-22T23:04:26.318597Z
# touched on 2025-05-22T23:21:34.010288Z

# touched on 2025-06-13T21:18:04.241081Z