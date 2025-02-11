module Models
  module Spree
    module AddressDecorator
      def self.prepended(base)
        base.class_eval do
          validate :allowed_states

          def allowed_states
            errors.add(:state_id, "not allowed") unless self.country.states.allowed_US_states.pluck(:id).include?(self.state_id)
          end
        end
      end

      ::Spree::Address.prepend self
    end
  end
end

# touched on 2025-05-22T22:38:16.612651Z
# touched on 2025-05-22T23:18:57.337900Z
# touched on 2025-05-22T23:42:54.691665Z
# touched on 2025-06-13T21:21:47.456534Z