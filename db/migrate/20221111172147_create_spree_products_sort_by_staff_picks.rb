class CreateSpreeProductsSortByStaffPicks < ActiveRecord::Migration[6.1]
  def change
    create_view :spree_products_sort_by_staff_picks
  end
end
