class Spree::Label < ApplicationRecord
  has_many :labels_products
  has_many :products, through: :labels_products

  after_commit :algolia_reindexing

  validates :tag, presence: true, uniqueness: {case_sensitive: false}
  after_save { products.find_each(&:touch) }

  def algolia_reindexing
    products.reindex!
  end
end

# touched on 2025-05-22T22:38:39.337910Z
# touched on 2025-05-22T22:47:35.595202Z
# touched on 2025-05-22T23:01:19.881854Z
# touched on 2025-05-22T23:43:54.081166Z
