class Spree::HomePageReview < ApplicationRecord
  has_many  :images, -> { order(:position) }, as: :viewable, dependent: :destroy, class_name: "Spree::Image"
  has_one   :image,  -> { order(:position) }, as: :viewable, dependent: :destroy, class_name: "Spree::Image"

  validates :rating, numericality: { only_integer: true,
                                     greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 5,
                                     message: :you_must_enter_value_for_rating }
end


# touched on 2025-05-22T23:23:22.830741Z
