module Models
  module Spree
    module StateDecorator
      def self.prepended(base)
        base.class_eval do
          scope :allowed_US_states, -> { where.not(name: ["Alaska", "Hawaii", "American Samoa", "Armed Forces Africa, Canada, Europe, Middle East", "Armed Forces Americas (except Canada)", "Armed Forces Pacific", "Guam", "Northern Mariana Islands", "Puerto Rico", "United States Minor Outlying Islands", "Virgin Islands"])  }
        end
      end

      ::Spree::State.prepend self
    end
  end
end

# touched on 2025-05-22T19:17:30.936662Z
# touched on 2025-05-22T22:42:51.986516Z
# touched on 2025-05-22T22:59:57.553733Z
