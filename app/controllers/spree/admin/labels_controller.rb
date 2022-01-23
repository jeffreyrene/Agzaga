module Spree
  class Admin::LabelsController < Spree::Admin::ResourceController
    helper Spree::BaseHelper

    before_action :find_label, only: [:show, :edit, :update, :destroy]

    def index
      @labels = Label.all
    end

    def new
      @label = Label.new
      authorize! :create, @label
    end

    def create

      @label = Label.new(label_params)
      authorize! :create, @label

      if @label.save!
        flash[:success] = "Label was created successfully"
        redirect_to admin_labels_path
      else
        render 'new'
      end

    end

    private

    def find_label
      @label = Label.find_by(id: params[:id])
    end

    def label_params
      params.require(:label).permit(:tag, :id)
    end
  end
end

# touched on 2025-05-22T23:08:19.189163Z
# touched on 2025-05-22T23:45:23.879175Z
