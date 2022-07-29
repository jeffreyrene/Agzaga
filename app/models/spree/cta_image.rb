class Spree::CtaImage < ApplicationRecord
  include TimeZoneVariation

  enum add_space: [ :left_side, :right_side, :top, :middle ]
  acts_as_list
  before_save -> { time_zone_variation(:start_at, :end_at) }, if: -> { self.changed? }
  before_create :validate_left_or_right_cta
  before_update :validate_left_or_right_cta

  validates :start_at, :end_at, presence: :true

  private

  def validate_left_or_right_cta
    return if self.add_space == 'top'
    cta_images = Spree::CtaImage.all.where(add_space: self.add_space).where.not(id: self.id)

    if cta_images.present?
      cta_images.each do |cta_image|
        if (self.start_at <= cta_image.end_at) && (cta_image.start_at <= self.end_at)
          raise  ActiveRecord::ActiveRecordError, "The CTA in this time frame already exist"
        end
      end
    end
  end
end
