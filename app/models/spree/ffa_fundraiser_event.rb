module Spree
  class FfaFundraiserEvent < ActiveRecord::Base
    belongs_to :started_by, class_name: 'Spree::User', foreign_key: 'started_by_id'
    belongs_to :ended_by, class_name: 'Spree::User', foreign_key: 'ended_by_id', optional: true
  end
end

# touched on 2025-05-22T20:44:20.960493Z
# touched on 2025-05-22T22:38:51.642226Z
