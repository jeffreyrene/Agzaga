module Spree::View
  class ChuckwagonOutdoorBoard < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-06-13T21:20:44.832431Z