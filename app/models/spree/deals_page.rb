class Spree::DealsPage < ApplicationRecord
  has_many  :images, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  has_one   :image, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
end

