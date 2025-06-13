# frozen_string_literal: true
# This migration comes from spree (originally 20190106184413)

require 'solidus/migrations/promotions_with_code_handlers'

class RemoveCodeFromSpreePromotions < ActiveRecord::Migration[5.1]
  class Promotion < ActiveRecord::Base
    self.table_name = "spree_promotions"
    self.ignored_columns = %w(type)
  end

  def up
    promotions_with_code = Promotion.where.not(code: [nil, ''])

    if promotions_with_code.any?
      # You have some promotions with "code" field present! This is not good
      # since we are going to remove that column.
      #
      self.class.promotions_with_code_handler.new(self, promotions_with_code).call
    end

    remove_index :spree_promotions, name: :index_spree_promotions_on_code
    remove_column :spree_promotions, :code
  end

  def down
    add_column :spree_promotions, :code, :string
    add_index :spree_promotions, :code, name: :index_spree_promotions_on_code
  end

  def self.promotions_with_code_handler
    # We propose different approaches, just pick the one that you prefer or
    # write your custom one.
    #
    # The fist one (raising an exception) is the default but you can
    # comment/uncomment the one then better fits you needs or use a
    # custom class or callable object.
    #
    Solidus::Migrations::PromotionWithCodeHandlers::RaiseException
    # Solidus::Migrations::PromotionWithCodeHandlers::MoveToSpreePromotionCode
    # Solidus::Migrations::PromotionWithCodeHandlers::DoNothing
  end
end

# touched on 2025-05-22T19:14:55.208772Z
# touched on 2025-05-22T20:44:56.524790Z
# touched on 2025-05-22T21:34:20.236974Z
# touched on 2025-05-22T22:38:16.610740Z
# touched on 2025-05-22T23:24:06.309628Z
# touched on 2025-05-22T23:37:58.591250Z
# touched on 2025-05-22T23:47:02.119625Z
# touched on 2025-06-13T21:20:02.547689Z