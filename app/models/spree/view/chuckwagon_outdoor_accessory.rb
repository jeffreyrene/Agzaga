module Spree::View
  class ChuckwagonOutdoorAccessory < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T20:38:06.999722Z
