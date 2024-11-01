module Models
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        base.class_eval do
          validate :confirm_tracking_code, if: Proc.new { |s| s.state_changed? }
        end

        private
        def confirm_tracking_code
          self.errors.add(:tracking, "can't be blank") if self.state == "shipped" && self.tracking.blank?
        end
      end

      ::Spree::Shipment.prepend self
    end
  end
end

# touched on 2025-05-22T19:13:46.985744Z
# touched on 2025-05-22T19:16:52.374156Z
# touched on 2025-05-22T20:38:32.834331Z
# touched on 2025-05-22T23:00:00.000301Z
# touched on 2025-05-22T23:30:06.121493Z

# touched on 2025-06-13T21:19:28.665146Z