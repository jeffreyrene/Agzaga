module Spree::View
  class ChuckwagonOutdoorBoard < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end
