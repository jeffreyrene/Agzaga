module Spree
  module Admin
    class LabelsProductsController < ResourceController
      before_action :load_label, only: :index

      def index
        @data = []
        @data = Spree::LabelsProduct.joins(:product)
                  .where(label_id: params.dig(:label, :id))
                    .order(:position) if params[:label].present?
      end

      def update_positions
        ActiveRecord::Base.transaction do
          positions = params[:positions]
          records = Spree::LabelsProduct.where(id: positions.keys).to_a

          positions.each do |id, index|
            records.find { |r| r.id == id.to_i }&.update!(position: index)
          end
        end

        respond_to do |format|
          format.js { head :no_content }
        end
      end

      private

      def load_label
        @label = Spree::Label.find_by_id(params.dig(:label, :id)) if params[:label].present?
        @label = Spree::Label.new if @label.nil?
      end
    end
  end
end

# touched on 2025-05-22T23:46:53.729760Z
# touched on 2025-06-13T21:21:00.007647Z