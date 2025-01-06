# frozen_string_literal: true

module Spree

  class FilterType < Spree::Base
    acts_as_list

    has_many :filter_values, -> { order(:position) }, dependent: :destroy, inverse_of: :filter_type
    has_and_belongs_to_many :products, dependent: :destroy

    validates :name, presence: true, uniqueness: { allow_blank: true, case_sensitive: true }
    validates :presentation, presence: true

    default_scope -> { order(:position) }

    accepts_nested_attributes_for :filter_values, reject_if: lambda { |ov| ov[:name].blank? && ov[:presentation].blank? }, allow_destroy: true
  end
end

# touched on 2025-05-22T20:44:54.117798Z
# touched on 2025-06-13T21:20:44.834825Z