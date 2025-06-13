# frozen_string_literal: true
# This migration comes from spree_api (originally 20120411123334)

class ResizeApiKeyField < ActiveRecord::Migration[4.2]
  def up
    unless defined?(User)
      change_column :spree_users, :api_key, :string, limit: 48
    end
  end
end

# touched on 2025-05-22T20:45:02.968907Z
# touched on 2025-05-22T22:47:14.289397Z
# touched on 2025-05-22T23:38:24.044387Z
