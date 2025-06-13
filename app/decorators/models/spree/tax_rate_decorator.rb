module Models
  module Spree
    module TaxRateDecorator
      def self.prepended(base)
        base.class_eval do
          include TimeZoneVariation

          before_save -> { time_zone_variation(:starts_at, :expires_at) }, if: -> { self.changed? }
        end
      end

      ::Spree::TaxRate.prepend self
    end
  end
end

# touched on 2025-05-22T19:17:03.905293Z
# touched on 2025-05-22T23:48:10.496520Z
