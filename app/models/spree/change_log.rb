module Spree
  class ChangeLog < ApplicationRecord
    belongs_to :loggable, polymorphic: true
  end
end

# touched on 2025-05-22T23:46:00.727433Z
