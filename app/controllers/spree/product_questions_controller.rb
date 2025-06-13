module Spree
  class ProductQuestionsController < Spree::StoreController
    helper Spree::BaseHelper
    before_action :load_product, only: [:index, :new, :create, :edit, :update]

    def index
      @product_questions = Spree::ProductQuestion.where(product: @product)
    end

    def new
      @product_question = Spree::ProductQuestion.new(product: @product)
    end


    def create
      @product_question = Spree::ProductQuestion.new(product_question_params)
      @product_question.product = @product
      @product_question.user = spree_current_user if spree_user_signed_in?
      if @product_question.save
        respond_to do |format|
          format.html do
            flash[:notice] = "Question was submitted successfully."
            redirect_to spree.product_path(@product)
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

    def permitted_product_question_attributes
      [:name, :question, :answer, :visibility]
    end

    def product_question_params
      params.require(:product_question).permit(permitted_product_question_attributes)
    end
  end
end

# touched on 2025-06-13T21:15:00.920234Z