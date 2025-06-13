module Spree
  class StockUpdatesController < ApplicationController
    def new
      @stock_update = Spree::StockUpdate.new
    end

    def create
      unless Spree::StockUpdate.exists?(email: params[:email], process: false, variant_id: params[:variant_id])
        @stock_update = Spree::StockUpdate.new(stock_update_params)
        respond_to do |format|
          if @stock_update.save
            format.js
          else
            format.html { render action: 'new' }
          end
        end
      end
    end

    private

    def stock_update_params
      params.permit(:email, :variant_id)
    end
  end
end

# touched on 2025-05-22T20:36:42.751411Z
# touched on 2025-05-22T23:01:49.470624Z
# touched on 2025-05-22T23:07:03.435202Z
