class Spree::LabelsProduct < ApplicationRecord
  acts_as_list
  belongs_to :product
  belongs_to :label
end

# touched on 2025-05-22T19:20:58.444616Z
# touched on 2025-05-22T20:44:56.522137Z
# touched on 2025-05-22T21:18:38.486719Z
# touched on 2025-05-22T22:47:24.119208Z
# touched on 2025-05-22T23:20:01.218085Z
