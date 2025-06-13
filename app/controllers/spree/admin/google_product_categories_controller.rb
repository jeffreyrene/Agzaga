class Spree::Admin::GoogleProductCategoriesController < Spree::Admin::BaseController
  before_action :update_google_product_category, only: :create
  before_action :load_product, only: :index

  def create
    redirect_to admin_google_product_categories_path
  end

  private

  def load_product
    @product = Spree::Product.new
  end

  def update_google_product_category
    if params[:product][:taxon_ids].present? && params[:product][:google_product_category].present?
      taxons_ids = params[:product][:taxon_ids].split(',')

      taxons_ids.each do |taxon_id|
        taxon_all_products = Spree::Taxon.find(taxon_id).all_products.uniq
        Spree::Product.where(id: taxon_all_products).update(google_product_category: params[:product][:google_product_category].to_i)
        flash[:success] = "Successfully Updated"
      end
    end
  end
end

# touched on 2025-05-22T23:36:43.660837Z
