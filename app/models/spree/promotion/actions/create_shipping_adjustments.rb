module Spree
  class Promotion < Spree::Base
    module Actions
      class CreateShippingAdjustments < Spree::PromotionAction
        include Spree::CalculatedAdjustments

        before_validation :ensure_action_has_calculator

        def perform(payload = {})
          order = payload[:order]
          promotion_code = payload[:promotion_code]

          results = order.shipments.map do |shipment|
            next false if shipment.adjustments.where(source: self).exists?

            shipment.adjustments.create!(
              order: shipment.order,
              amount: compute_amount(shipment),
              source: self,
              promotion_code: promotion_code,
              label: label,
            )

            true
          end

          results.any? { |result| result == true }
        end

        def label
          "#{I18n.t('spree.promotion')} (#{promotion.name})"
        end

        def compute_amount(shipment)
          return 0 unless shipment.present?

          shipment_discount = calculator.compute(shipment)
          shipment_discount = shipment_discount.abs * -1
        end

        def remove_from(order)
          order.shipments.each do |shipment|
            shipment.adjustments.each do |adjustment|
              if adjustment.source == self
                shipment.adjustments.destroy(adjustment)
              end
            end
          end
        end

        private

        def ensure_action_has_calculator
          return if calculator
          self.calculator = Spree::Calculator::Shipping::ShippingDiscountCalculator.new
        end
      end
    end
  end
end



# touched on 2025-05-22T19:15:40.550990Z
# touched on 2025-05-22T19:22:31.453194Z
# touched on 2025-05-22T22:43:12.016112Z
# touched on 2025-05-22T23:48:35.274007Z
