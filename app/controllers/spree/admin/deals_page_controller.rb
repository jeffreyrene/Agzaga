class Spree::Admin::DealsPageController < Spree::Admin::ResourceController

  def index
    @deals_page = Spree::DealsPage.all
  end

  def new
    @deals_page = Spree::DealsPage.new
    authorize! :create, @deals_page
  end

  def edit
    @deals_page = Spree::DealsPage.find(params[:id])
    if @deals_page.nil?
      flash[:error] = "No Deal"
    end
    authorize! :update, @deals_page
  end

  def create
    @deals_page = Spree::DealsPage.new(deals_params)
    params[:deals_page][:images]&.each do |image|
      @deals_page.images.new(attachment: image)
    end

    authorize! :create, @deals_page
    if @deals_page.save
      flash[:notice] = I18n.t('spree.deal_successfully_added')
      redirect_to admin_deals_page_index_path
    else
      render :new
    end
  end

  def update
    @deals_page = Spree::DealsPage.find(params[:id])
    params[:deals_page][:images]&.each do |image|
      @deals_page.images.new(attachment: image)
    end

    authorize! :update, @deals_page
    if @deals_page.update(deals_params)
      flash[:notice] = I18n.t('spree.deal_successfully_updated')
      redirect_to admin_deals_page_index_path
    else
      render :edit
    end
  end

  def edit_image
    @deals_page = Spree::DealsPage.find(params[:id])
    image_value = params[:image][:alt]

    @image = Spree::Image.find(params[:format])
    if @image.present?
      @image.update(alt: image_value)
    end

    if @deals_page.nil?
      flash[:error] = "No Deal"
    end
    authorize! :update, @deals_page
  end

  def remove_image
    @image = Spree::Image.find(params[:format])
    if @image.present?
      @image.destroy
    end
  end

  def permitted_deals_attributes
    [:title, :description, :tag, :images, :visibility]
  end

  def deals_params
    params.require(:deals_page).permit(permitted_deals_attributes)
  end

end

# touched on 2025-05-22T23:37:13.127580Z
