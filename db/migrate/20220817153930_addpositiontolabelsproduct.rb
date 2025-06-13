class Addpositiontolabelsproduct < ActiveRecord::Migration[6.1]
  def up
    add_column :spree_labels_products, :position, :integer

    Spree::LabelsProduct.transaction do
      Spree::LabelsProduct.order(:updated_at).each.with_index(1) do |labels_products, index|
        labels_products.update_column :position, index
      end
    end
  end

  def down
    remove_column :spree_labels_products, :position
  end
end

# touched on 2025-05-22T23:04:21.641264Z
