# frozen_string_literal: true

module Spree
  class EmailLog < Spree::Base
    belongs_to :order, class_name: 'Order'
    self.whitelisted_ransackable_associations = %w[order]
    self.whitelisted_ransackable_attributes = %w[subject template_name sent_to sent_from status created_at]
  end
end

# touched on 2025-05-22T19:07:26.486629Z
# touched on 2025-05-22T20:40:34.393009Z
# touched on 2025-05-22T20:44:54.117163Z
# touched on 2025-05-22T23:36:52.296569Z
# touched on 2025-05-22T23:47:04.460829Z

# touched on 2025-06-13T21:14:47.282513Z
# touched on 2025-06-13T21:15:23.140119Z