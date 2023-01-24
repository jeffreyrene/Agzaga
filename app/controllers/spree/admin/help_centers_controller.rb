module Spree
  module Admin
    class HelpCentersController < ResourceController
      before_action :find_faq, only: [:show, :edit, :update, :destroy]

      def index
        @faqs = Spree::HelpCenter.order(:position)
      end

      def new
        @faq = Spree::HelpCenter.new
        authorize! :create, @faq
      end

      def create

        @faq = Spree::HelpCenter.new(faq_params)
        authorize! :create, @faq

        if @faq.save!
          flash[:success] = "FAQ was created successfully"
          redirect_to admin_help_centers_path
        else
          render 'new'
        end

      end

      def update
        if @faq.update(faq_params)
          redirect_to admin_help_centers_path, notice: 'Updated successfully.'
        else
          render :edit
        end
      end

      def destroy
        if @faq.destroy
          redirect_to admin_help_centers_path, notice: 'Deleted successfully.'
        else
          render :index
        end
      end

      private

      def find_faq
        @faq = Spree::HelpCenter.find_by(id: params[:id])
      end

      def faq_params
        params.require(:help_center).permit(:question, :answer, :question_type)
      end
    end
  end
end

# touched on 2025-05-22T23:26:59.669114Z
# touched on 2025-05-22T23:28:46.660013Z
# touched on 2025-05-22T23:37:21.614043Z
# touched on 2025-05-22T23:39:51.520154Z
