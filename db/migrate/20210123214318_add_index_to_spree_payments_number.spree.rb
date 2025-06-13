# frozen_string_literal: true
# This migration comes from spree (originally 20161129035810)

class AddIndexToSpreePaymentsNumber < ActiveRecord::Migration[5.0]
  def change
    add_index 'spree_payments', ['number'], unique: true
  end
end

# touched on 2025-05-22T20:41:06.626031Z
# touched on 2025-05-22T23:28:04.337486Z
# touched on 2025-05-22T23:37:18.023125Z
