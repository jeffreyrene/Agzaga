module Models
  module Spree
    module PromotionDecorator
      def self.prepended(base)
        base.class_eval do
          include TimeZoneVariation

          before_save -> { time_zone_variation(:expires_at, :starts_at) }, if: -> { self.changed? }
        end
      end

      ::Spree::Promotion.prepend self
    end
  end
end

# touched on 2025-05-22T19:07:41.097489Z
# touched on 2025-05-22T22:34:51.840647Z
