module Spree
  class Admin::ContactsController < Spree::Admin::ResourceController
    helper Spree::BaseHelper

    def index
      @contacts = Spree::Contact.order(id: :desc).page(params.dig(:page) || 1 ).per(30)
    end

    def show
      @contact = Spree::Contact.find(params[:id])
    end
  end
end

# touched on 2025-05-22T22:52:38.468878Z
# touched on 2025-05-22T23:02:56.666369Z
