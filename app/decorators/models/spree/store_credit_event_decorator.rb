module Models
  module Spree
    module StoreCreditEventDecorator
      def self.prepended(base)
        base.class_eval do
          after_create :sned_store_credit_added_email

          def sned_store_credit_added_email
            if Rails.env.production? && self.action == 'allocation'
              SendStoreCreditAddedEmailJob.perform_now(self)
            end
          end
        end
      end

      ::Spree::StoreCreditEvent.prepend self
    end
  end
end

# touched on 2025-05-22T22:32:12.722690Z
# touched on 2025-06-13T21:17:50.626687Z