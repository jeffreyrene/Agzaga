module Spree
  class Admin::CtaImagesController < Spree::Admin::BaseController
    before_action :set_cta_image, only: %w[ show edit update destroy ]
    helper Spree::BaseHelper

    def new
      @cta_image = Spree::CtaImage.new
    end

    def create
      @cta_image = Spree::CtaImage.new cta_images_params

      respond_to do |format|
        begin
          if @cta_image.save
            format.html { redirect_to admin_cta_images_url, notice: "Cta Image was successfully created." }
            format.json { render :show, status: :created, location: @cta_image }
          else
            format.html { render :new, status: :unprocessable_entity }
          end
        rescue ActiveRecord::ActiveRecordError => error
          flash[:error] = error.message
          format.html { redirect_to admin_cta_images_url }
        end
      end

    end

    def index
      @cta_images = Spree::CtaImage.all
    end

    def edit
    end

    def update_positions
      ActiveRecord::Base.transaction do
        positions = params[:positions]
        records = Spree::CtaImage.where(id: positions.keys).to_a

        positions.each do |id, index|
          records.find { |r| r.id == id.to_i }&.update!(position: index)
        end
      end

      respond_to do |format|
        format.js { head :no_content }
      end
    end

    def update
      respond_to do |format|
        begin
          if @cta_image.update(cta_images_params)
            format.html { redirect_to admin_cta_images_url, notice: "Cta_image was successfully updated." }
            format.json { render :show, status: :ok, location: @cta_iage }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @cta_image.errors, status: :unprocessable_entity }
          end
        rescue ActiveRecord::ActiveRecordError => error
          flash[:error] = error.message
          format.html { redirect_to admin_cta_images_url }
        end
      end
    end

    def destroy
      @cta_image.destroy
      respond_to do |format|
        format.html { redirect_to admin_cta_images_url, notice: "Cta_image was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def set_cta_image
      @cta_image = Spree::CtaImage.find(params[:id])
    end

    def cta_images_params
      params.require(:cta_image).permit(:start_at, :end_at, :desktop_link, :tab_link, :mobile_link, :redirect_to, :add_space)
    end
  end
end

# touched on 2025-05-22T22:36:10.029058Z
# touched on 2025-05-22T22:47:14.290330Z
# touched on 2025-05-22T23:37:18.019996Z
# touched on 2025-06-13T21:17:16.537277Z