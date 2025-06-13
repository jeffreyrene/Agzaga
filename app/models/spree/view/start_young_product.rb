module Spree::View
  class StartYoungProduct < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T22:49:27.592464Z
# touched on 2025-06-13T21:15:33.735717Z