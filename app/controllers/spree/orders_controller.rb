# frozen_string_literal: true

module Spree
  class OrdersController < Spree::StoreController
    helper 'spree/products', 'spree/orders'

    respond_to :html

    before_action :store_guest_token
    before_action :assign_order, only: :update
    before_action :assign_custom_hose_configuration, only: :destroy_custom_hose_from_line_items
    before_action :set_saved_items_vars, only: :populate
    before_action :ensure_sufficient_stock_lines, only: :populate

    # note: do not lock the #edit action because that's where we redirect when we fail to acquire a lock
    around_action :lock_order, only: :update
    skip_before_action :verify_authenticity_token, only: [:populate]
    rescue_from Spree::Order::InsufficientStock, with: :insufficient_stock_error

    def ensure_sufficient_stock_lines
      @order = current_order(create_order_if_necessary: true)
      @variant  = Spree::Variant.find(params[:variant_id]) unless params.dig(:custom_hose).present?
      insufficiant_item = @order.insufficient_stock_lines.any? {|line_item| line_item.variant == @variant}
      if @order.insufficient_stock_lines.present? && insufficiant_item
        out_of_stock_items = @order.insufficient_stock_lines.collect(&:name).to_sentence
        flash[:error] = t('spree.inventory_error_flash_for_insufficient_quantity', names: out_of_stock_items)
        redirect_to spree.cart_path
      end
    end

    def show
      @order = Spree::Order.find_by!(number: params[:id])
      authorize! :show, @order, cookies.signed[:guest_token]
      render layout: 'spree/layouts/spree_checkout'
    end

    def update
      authorize! :update, @order, cookies.signed[:guest_token]
      if @order.contents.update_cart(order_params)
        address_saved = @order&.user&.bill_address&.present? && @order&.user&.ship_address&.present?
        pick_up_person_saved = @order.pick_up_order? ? !@order.pick_up_person.firstname.blank? : true

        @order.next if params.key?(:checkout) && @order.cart?
        @order.next if (address_saved && pick_up_person_saved)

        @order.update(is_pickup: false) if !@order.line_items.any? && @order.pick_up_order?

        @order.apply_shipping_promotions

        respond_with(@order) do |format|
          format.html do
            if params.key?(:checkout)
              if @order.present?
                redirect_to checkout_state_path(@order.state)
              else
                redirect_to cart_path
              end
            else
              redirect_to cart_path
            end
          end
          format.js
        end
      else
        respond_with(@order)
      end
    end

    # Shows the current incomplete order from the session
    def edit
      if spree_user_signed_in?
        @saveditems = try_spree_current_user.save_items
      end
      @order = current_order(build_order_if_necessary: true)
      authorize! :edit, @order, cookies.signed[:guest_token]
      associate_user

      render layout: 'spree/layouts/spree_cart'
      if params[:id] && @order.number != params[:id]
        flash[:error] = t('spree.cannot_edit_orders')
        redirect_to cart_path
      end
    end

    def destroy_line_item
      if @order = current_order
        @line_item = @order.line_items.find_by(id: params[:id])
        @upsell_products = Spree::Product.available.joins(:labels_products).deal_prodcuts('Upsell Products').order("spree_labels_products.position") if params[:upsell].present?

        if @line_item.present?

          if @line_item.product.for_custom_hose?
            @order.line_items.each { |line_item| line_item.quantity = 0 if line_item.product.for_custom_hose? }
            @order.line_items = @order.line_items.select { |li| li.quantity > 0 }
            CustomHoseConfiguration.where(order_id: @order.id).destroy_all
          else
            @line_item.destroy
          end
          @order.ensure_updated_shipments
          @order.recalculate
          @order.create_proposed_shipments if params[:recalculate_shipping].present?
          @order.apply_shipping_promotions
        end
      end
      respond_with(@order) do |format|
        format.js
        format.html do
          if @order.present?
            redirect_to checkout_state_path(@order.state)
          else
            redirect_to cart_path
          end
        end
      end
    end

    def increase_quantity
      if @order = current_order
        @line_item = @order.line_items.find_by(id: params[:id])
        max_value = @line_item.variant.total_on_hand
        if ( @line_item.present? && @line_item.quantity < max_value )  || @line_item.variant.is_backorderable?
          @line_item.quantity = @line_item.quantity + 1
          @line_item.save!
          @order.ensure_updated_shipments
          @order.apply_shipping_promotions
          @order.recalculate
        end
      end
      respond_with(@order) do |format|
        format.js
      end
    end

    def decrease_quantity
      if @order = current_order
        @line_item = @order.line_items.find_by(id: params[:id])
        if ( @line_item.present? &&  @line_item.quantity >= 1)
          @line_item.quantity = @line_item.quantity - 1
          @line_item.save!
          @order.ensure_updated_shipments
          @order.apply_shipping_promotions
          @order.recalculate
        end
      end
      respond_with(@order) do |format|
        format.js
      end
    end

    def update_line_item_quantity
      if @order = current_order
        @line_item = @order.line_items.find_by(id: params[:id])
        updated_quantity = params[:order].values[0].values[0].values[0].to_i

        if ( @line_item.present? &&  @line_item.quantity >= 1)
          @line_item.quantity = updated_quantity
          @line_item.save!
          @order.recalculate
          @order.create_proposed_shipments if params[:recalculate_shipping].present?
          @order.apply_shipping_promotions
          @order.recalculate
        else
          @line_item.destroy
          @order.recalculate
        end
      end
      respond_with(@order) do |format|
        format.js
        format.html do
          if @order.present?
            redirect_to checkout_state_path(@order.state)
          else
            redirect_to cart_path
          end
        end
      end
    end

    def update_upsell_modal
      @upsell_products = Spree::Product.available.joins(:labels_products).deal_prodcuts('Upsell Products').order("spree_labels_products.position") if params[:upsell].present?
      @order = current_order

      respond_with(@order) do |format|
        format.js
      end
    end

    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      @order = current_order(create_order_if_necessary: true)
      assign_utm_source if cookies.has_key?(:utm_source)
      assign_ref if cookies.has_key?(:ref)
      assign_tar if cookies.has_key?(:tar)

      authorize! :update, @order, cookies.signed[:guest_token]
      @upsell_products = Spree::Product.available.joins(:labels_products).deal_prodcuts('Upsell Products').order("spree_labels_products.position") if params[:upsell].present?

      @variant  = Spree::Variant.find(params[:variant_id]) unless params.dig(:custom_hose).present?
      @variant_id = params[:variant_id] if params[:variant_id]
      @modal_v2_quantity =  params.dig(:custom_hose).present? ? false : true

      if params[:pick_up].present? && !@order.pick_up_order?
        @order.update(is_pickup: true)
        @order.empty! if @order.line_items.any?
        @remove_products = true
      end

      quantity = params[:quantity].present? ? params[:quantity].to_i : 1

      # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
      if !quantity.between?(1, 2_147_483_647)
        @order.errors.add(:base, t('spree.please_enter_reasonable_quantity'))
      else
        begin
          if params.dig(:custom_hose).present? && !@order.pick_up_order?
            create_custom_hose_configurations_and_add_to_cart(quantity)
            flash[:notice] = 'Added Successfully'
          else
            if @order.pick_up_order? && !params[:pick_up].present?
              @pick_up_order_present = true
            else
              @order.update(state: 'payment') if !@order.checkout_steps.include?(@order.state) && @order.state != 'cart'
              @line_item = @order.contents.add(@variant, quantity)
            end
          end
        rescue ActiveRecord::RecordInvalid => error
          @order.errors.add(:base, error.record.errors.full_messages.join(", "))
        end
      end

      remove_item_from_saved_item

      respond_with(@order) do |format|
        format.html do
          if @order.errors.any?
            flash[:error] = @order.errors.full_messages.join(", ")
            redirect_back_or_default(spree.root_path)
            return
          else
            redirect_to cart_path
          end
        end
        format.js
      end
    end

    def populate_redirect
      flash[:error] = t('spree.populate_get_error')
      # redirect_to spree.cart_path
    end

    def empty
      if @order = current_order
        authorize! :update, @order, cookies.signed[:guest_token]
        @order.empty!
        @order.update(is_pickup: false) if @order.pick_up_order?
      end
      respond_with(@order) do |format|
        format.html do
          # redirect_to spree.cart_path
        end
        format.js
      end
    end

    def accurate_title
      if @order && @order.completed?
        t('spree.order_number', number: @order.number)
      else
        t('spree.shopping_cart')
      end
    end

    def destroy_custom_hose_from_line_items; end

    private

    def insufficient_stock_error
      if @order.insufficient_stock_lines.present?
        out_of_stock_items = @order.insufficient_stock_lines.collect(&:name).to_sentence
        flash[:error] = t('spree.inventory_error_flash_for_insufficient_quantity', names: out_of_stock_items)
        redirect_to spree.cart_path
      end
    end

    def store_guest_token
      cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
    end

    def order_params
      if params[:order]
        params[:order].permit(*permitted_order_attributes)
      else
        {}
      end
    end

    def find_device_type
      user_agent = request.user_agent.downcase
  
      device_type = case user_agent
      when /iphone/
        'mobile-iOS'
      when /android/
        user_agent.include?('mobile') ? 'mobile-android' : 'tablet-android'
      when /ipad/
        'tablet-iOS'
      else
        'Desktop'
      end

      @order.update(device_type: device_type)
    end

    def assign_order
      @order = current_order

      find_device_type if @order

      unless @order
        flash[:error] = t('spree.order_not_found')
        redirect_to(root_path) && return
      end
    end

    def assign_custom_hose_configuration
      @order = current_order
      @custom_hose_configuration = CustomHoseConfiguration.find_by(id: params[:id])
      if @custom_hose_configuration.present?
        @line_item = @order.line_items.find_by(variant_id:@custom_hose_configuration.custom_hose)
        @line_item.update(quantity:(@line_item.quantity - @custom_hose_configuration.length))
        if @line_item.quantity == 0
          @line_item.destroy
        end

        decrease_custom_hose_quantity(@custom_hose_configuration.fitting_1)

        decrease_custom_hose_quantity(@custom_hose_configuration.fitting_2)

        decrease_custom_hose_quantity(@custom_hose_configuration.assembly_fee)

        @order.recalculate
        if @custom_hose_configuration.destroy
          redirect_to custom_hose_generator_index_path, notice: 'Remove Successfully'
        end
      else
        redirect_to custom_hose_generator_index_path
      end
    end

    def decrease_custom_hose_quantity(variant_id)
      @line_item = @order.line_items.find_by(variant_id: variant_id)
      if @line_item.present?
        @line_item.update(quantity: (@line_item.quantity-1))

        if @line_item.quantity == 0
          @line_item.destroy
        end
      else
        redirect_to custom_hose_generator_index_path
      end
    end

    def set_saved_items_vars
      return true unless params[:from_undo].present?

      @from_undo = params[:from_undo]
      @render_slider_partial = params[:render_slider_partial]
    end

    def remove_item_from_saved_item
      if params[:variant_id].present? && try_spree_current_user.present?
        destroy_save_items = try_spree_current_user&.save_items&.find_by(variant_id: params[:variant_id])&.destroy
        flash[:success] = "Removed that product from cart's saved items" if destroy_save_items && @from_undo.blank?
      end
    end

    def assign_utm_source
      if (cookies[:utm_source].present? && @order.utm_source != cookies[:utm_source])
        @order.utm_source = cookies[:utm_source]
        cookies.delete(:utm_source)
      end
    end

    def assign_tar
      if (cookies[:tar].present? && @order.tar != cookies[:tar])
        @order.tar = cookies[:tar]
        cookies.delete(:tar)
      end
    end

    def assign_ref
      if (cookies[:ref].present? && @order.ref != cookies[:ref])
        @order.ref = cookies[:ref]
        cookies.delete(:ref)
      end
    end

    def create_custom_hose_configurations_and_add_to_cart quantity
      add_custom_hose_to_cart(quantity)
      create_custom_hose_configurations
    end

    def add_custom_hose_to_cart(quantity)
      custom_hose_variant_id = params.dig(:custom_hose, :variant_id)
      fitting_1_variant_id = params.dig(:fitting_1_variant_id)
      fitting_2_variant_id = params.dig(:fitting_2_variant_id)
      hose_assembly_fee = params.dig(:hose_assembly_fee) if params.dig(:hose_assembly_fee).present?

      cutom_hose_configurations = Spree::Variant.find([ custom_hose_variant_id, fitting_1_variant_id, fitting_2_variant_id, hose_assembly_fee])

      cutom_hose_configurations.each do | cutom_hose_configuration |
        product_type = cutom_hose_configuration&.product&.product_type
        same_hose_fitting = fitting_1_variant_id == fitting_2_variant_id ? true : false
        item_quantity = product_type == 'custom_hose' ? params.dig(:order, :length) : (product_type == 'hose_fitting' && same_hose_fitting) ? (quantity + 1) : quantity
        @order.contents.add(cutom_hose_configuration, item_quantity)
      end
    end

    def create_custom_hose_configurations
      @order.custom_hose_configurations.create(custom_hose_id: params[:custom_hose][:variant_id],
        fitting_1_id: params[:fitting_1_variant_id],
        fitting_2_id: params[:fitting_2_variant_id],
        assembly_fee_id: params[:hose_assembly_fee],
        length: params[:order][:length])
    end
  end
end

# touched on 2025-05-22T22:32:42.145140Z
# touched on 2025-05-22T23:06:11.779994Z
