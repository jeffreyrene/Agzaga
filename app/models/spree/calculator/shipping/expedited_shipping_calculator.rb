module Spree
  module Calculator::Shipping
    class ExpeditedShippingCalculator < ShippingCalculator

      preference :percentage_on_standard_rate, :decimal, default: 0.0
      preference :currency, :string, default: ->{ Spree::Config[:currency] }

      def self.description
        "Expedited Shipping Calculator"
      end

      def compute_package(package)
        standard_rate = Spree::ShippingMethod.find_by(admin_name: 'Standard Shipping Rate')&.calculator&.compute_package(package)

        standard_rate + ( standard_rate * ( preferred_percentage_on_standard_rate / 100 ))
      end

    end
  end
end

# touched on 2025-05-22T19:22:35.473290Z
