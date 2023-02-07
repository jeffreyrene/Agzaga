# frozen_string_literal: true

module Spree
  class Variant < Spree::Base
    has_many :change_logs, as: :loggable
    def get_max_stock
      Spree::Stock::Quantifier.new(self).max_stock
    end
  end
end

require_dependency 'spree/variant/scopes'

# touched on 2025-05-22T22:59:55.015168Z
