module Spree::View
  class ChuckwagonPreOrder < ApplicationRecord
    self.primary_key = :id

    def read_only?
      true
    end
  end
end

# touched on 2025-05-22T19:23:21.458398Z
# touched on 2025-05-22T22:43:18.700123Z
# touched on 2025-05-22T23:19:46.080243Z
