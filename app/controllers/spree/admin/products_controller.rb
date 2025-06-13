# frozen_string_literal: true
module Spree
  module Admin
    class ProductsController < ResourceController
      helper 'spree/products'
      before_action :load_data, except: [:index]
      update.before :update_before
      helper_method :clone_object_url
      before_action :split_params, only: [:create, :update]
      before_action :normalize_variant_property_rules, only: [:update]
      before_action :set_default_tax_category, only: [:new, :edit]

      def show
        redirect_to action: :edit
      end

      def export
        ExportProductJob.perform_later(spree_current_user)
        flash[:success] = 'Export products will be emailed to you shortly'
        redirect_to action: :index
      end

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def destroy
        @product = Spree::Product.friendly.find(params[:id])
        @product.discard

        flash[:success] = t('spree.notice_messages.product_deleted')

        respond_with(@product) do |format|
          format.html { redirect_to collection_url }
          format.js { render_js_for_destroy }
        end
      end

      def clone
        @new = @product.duplicate
        @new.avg_rating = 0
        @new.reviews_count = 0

        if @new.save
          flash[:success] = t('spree.notice_messages.product_cloned')
        else
          flash[:error] = t('spree.notice_messages.product_not_cloned')
        end

        redirect_to edit_admin_product_url(@new)
      end

      def group_products
        @group_products = Kaminari.paginate_array(@product.products).page(params[:page]||1).per(Spree::Config[:admin_products_per_page])
      end

      def add_group_products
        products = Spree::Product.where(id: params[:product][:product_ids].reject(&:blank?))
        @product.products = products
        flash[:success] = "Successfully added products to this set"
        redirect_to admin_add_group_products_path
      end

      def remove_group_product
        @product.products.delete(Spree::Product.find(params[:product_id]))
        flash[:success] = "Successfully removed product"
        redirect_to admin_group_products_path
      end

      def add_on_product
        @add_products = Kaminari.paginate_array(@product.add_ons).page(params[:page]||1).per(Spree::Config[:admin_products_per_page])
      end

      def add_add_on_product
        products = Spree::Product.where(id: params[:product][:product_ids].reject(&:blank?))
        @product.add_ons = products
        flash[:success] = "Successfully added products to this set"
        redirect_to admin_add_on_products_path
      end

      def remove_add_on_product
        @product.add_ons.delete(Spree::Product.find(params[:product_id]))
        flash[:success] = "Successfully removed product"
        redirect_to admin_group_products_path
      end

      def bulk_update_variant_prices
        return unless params[:bulk_update_variant_prices].present?

        if (@product.bulk_update_variant_prices)
          flash[:success] = "Variant prices have been successfully updated!"
        else
          flash[:error] = "Something went wrong"
        end

        redirect_to admin_product_prices_path(@product.slug)
      end

      private

      def set_default_tax_category
        @product.tax_category_id ||= @default_tax_category&.id
      end

      def split_params
        if params[:product][:taxon_ids].present?
          params[:product][:taxon_ids] = params[:product][:taxon_ids].split(',')
        end
        if params[:product][:option_type_ids].present?
          params[:product][:option_type_ids] = params[:product][:option_type_ids].split(',')
        end
      end

      def find_resource
        Spree::Product.with_discarded.friendly.find(params[:id])
      end

      def location_after_save
        if updating_variant_property_rules?
          url_params = {}
          url_params[:ovi] = []
          params[:product][:variant_property_rules_attributes].each do |_index, param_attrs|
            url_params[:ovi] += param_attrs[:option_value_ids]
          end
          spree.admin_product_product_properties_url(@product, url_params)
        else
          spree.edit_admin_product_url(@product)
        end
      end

      def load_data
        @tax_categories = Spree::TaxCategory.order(:name)
        @default_tax_category = @tax_categories.detect(&:is_default)
        @shipping_categories = Spree::ShippingCategory.order(:name)
      end

      def collection
        return @collection if @collection
        params[:q] ||= {}
        params[:q][:s] ||= "name asc"
        # @search needs to be defined as this is passed to search_form_for
        @search = super.ransack(params[:q])
        @collection = @search.result.
              order(id: :asc).
              includes(product_includes).uniq
        @collection = Kaminari.paginate_array(@collection).page(params[:page]).per(Spree::Config[:admin_products_per_page])
      end

      def update_before
        # note: we only reset the product properties if we're receiving a post
        #       from the form on that tab
        return unless params[:clear_product_properties]
        params[:product] ||= {}
      end

      def product_includes
        [:variant_images, { variants: [:images], master: [:images, :default_price] }]
      end

      def clone_object_url(resource)
        clone_admin_product_url resource
      end

      def variant_stock_includes
        [:images, stock_items: :stock_location, option_values: :option_type]
      end

      def variant_scope
        @product.variants
      end

      def updating_variant_property_rules?
        params[:product][:variant_property_rules_attributes].present?
      end

      def render_after_update_error
        # Stops people submitting blank slugs, causing errors when they try to
        # update the product again
        @product.slug = @product.slug_was if @product.slug.blank?
        render action: 'edit'
      end

      def normalize_variant_property_rules
        return unless updating_variant_property_rules?

        params[:product][:variant_property_rules_attributes].each do |_index, param_attrs|
          param_attrs[:option_value_ids] = param_attrs[:option_value_ids].split(',')
        end
      end
    end
  end
end

# touched on 2025-05-22T21:51:28.224297Z
# touched on 2025-05-22T23:28:09.703534Z
# touched on 2025-05-22T23:28:55.950716Z
# touched on 2025-05-22T23:42:13.350197Z
# touched on 2025-05-22T23:43:57.446157Z
