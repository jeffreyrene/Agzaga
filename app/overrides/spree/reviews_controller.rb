# frozen_string_literal: true

class Spree::ReviewsController < Spree::StoreController
  helper Spree::BaseHelper
  before_action :load_product, only: [:index, :new, :create, :edit, :update]
  # save if all ok
  def create
    review_params[:rating].sub!(/\s*[^0-9]*\z/, '') if review_params[:rating].present?

    @review = Spree::Review.new(review_params)
    @review.product = @product
    @review.user = spree_current_user if spree_user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]
    # Handle images
    params[:review][:images]&.each do |image|
      @review.images.new(attachment: image)
    end

    authorize! :create, @review
    if @review.save
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t('spree.review_successfully_submitted')
          redirect_to reviews_form_product_path(@product)
        end
        format.js
      end
    else
      respond_to do |format|
        format.html do
          render :new
        end
        format.js
      end
    end
  end

  private

  def load_product
    @product = Spree::Product.friendly.find(params[:product_id])
  end

  def permitted_review_attributes
    [:rating, :title, :review, :name, :show_identifier, :images]
  end

  def review_params
    params.require(:review).permit(permitted_review_attributes)
  end
end

# touched on 2025-05-22T19:24:47.936773Z
# touched on 2025-05-22T23:05:14.241028Z
# touched on 2025-05-22T23:08:24.196560Z
# touched on 2025-05-22T23:08:31.537126Z
# touched on 2025-05-22T23:29:05.122357Z
