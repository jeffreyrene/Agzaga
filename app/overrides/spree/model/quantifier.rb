# frozen_string_literal: true

module Spree
  module Stock
    class Quantifier
      attr_reader :stock_items
      def max_stock
        stock_items.sum(:max_stock)
      end

      def backorderable?
        stock_items.any?(&:backorderable)
      end

      # Checks if it is possible to supply a given number of units.
      #
      # @param required [Fixnum] the number of required stock units
      # @return [Boolean] true if we have the required amount on hand or the
      #   variant is backorderable, otherwise false
      def can_supply?(required)
        total_on_hand >= required || backorderable? && required <= 500
      end

    end
  end
end

# touched on 2025-05-22T19:07:32.855375Z
# touched on 2025-05-22T20:38:05.164731Z
# touched on 2025-05-22T20:38:45.722632Z
# touched on 2025-05-22T20:44:42.716480Z
# touched on 2025-05-22T22:47:16.880150Z
# touched on 2025-06-13T21:14:53.889801Z