class Spree::Admin::HomePageReviewsController < Spree::Admin::ResourceController
 helper Spree::ReviewsHelper

  def index
    @home_page_reviews = Spree::HomePageReview.all.order('position asc')
  end

  def new
    @home_page_review = Spree::HomePageReview.new
    authorize! :create, @home_page_review
  end

  def edit
    @home_page_review = Spree::HomePageReview.find(params[:id])
    if @home_page_review.nil?
      flash[:error] = "No Review"
    end
    authorize! :update, @home_page_review
  end

  # save if all ok
  def create
    review_params[:rating].sub!(/\s*[^0-9]*\z/, '') if review_params[:rating].present?

    @home_page_review = Spree::HomePageReview.new(review_params)
    params[:home_page_review][:images]&.each do |image|
      @home_page_review.images.new(attachment: image)
    end

    authorize! :create, @home_page_review
    if @home_page_review.save
      flash[:notice] = I18n.t('spree.review_successfully_added')
      redirect_to admin_home_page_reviews_path
    else
      render :new
    end
  end

  def update
    review_params[:rating].sub!(/\s*[^0-9]*\z/, '') if params[:home_page_review][:rating].present?

    @home_page_review = Spree::HomePageReview.find(params[:id])

    # Handle images
    params[:home_page_review][:images]&.each do |image|
      @home_page_review.image.update(attachment: image)
    end

    authorize! :update, @home_page_review
    if @home_page_review.update(review_params)
      flash[:notice] = I18n.t('spree.review_successfully_updated')
      redirect_to admin_home_page_reviews_path
    else
      render :edit
    end
  end

  def update_positions
    ActiveRecord::Base.transaction do
      positions = params[:positions]
      records = Spree::HomePageReview.where(id: positions.keys).to_a

      positions.each do |id, index|
        records.find { |r| r.id == id.to_i }&.update!(position: index)
      end
    end

    respond_to do |format|
      format.js { head :no_content }
    end
  end

  private

  def permitted_review_attributes
    [:rating, :title, :comment, :name, :images, :rating, :review_date, :visibility]
  end

  def review_params
    params.require(:home_page_review).permit(permitted_review_attributes)
  end
end

# touched on 2025-06-13T21:19:21.989481Z