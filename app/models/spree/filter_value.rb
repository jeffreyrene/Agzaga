# frozen_string_literal: true

module Spree
  class FilterValue < Spree::Base
    belongs_to :filter_type, class_name: 'FilterType', inverse_of: :filter_values, optional: true
    acts_as_list scope: :filter_type

    has_and_belongs_to_many :products, dependent: :destroy

    validates :name, presence: true, uniqueness: { scope: :filter_type_id, allow_blank: true, case_sensitive: true }
    validates :presentation, presence: true

    delegate :name, :presentation, to: :filter_type, prefix: :filter_type, allow_nil: true

    self.whitelisted_ransackable_attributes = %w[name presentation]


    def presentation_with_filter_type
      "#{filter_type.presentation} - #{presentation}"
    end
  end
end

# touched on 2025-05-22T23:26:41.298992Z
