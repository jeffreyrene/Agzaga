# frozen_string_literal: true
# This migration comes from spree (originally 20160420181916)

class MigrateCreditCardsToWalletPaymentSources < ActiveRecord::Migration[4.2]
  class CreditCard < ActiveRecord::Base
    self.table_name = 'spree_credit_cards'
  end
  class WalletPaymentSource < ActiveRecord::Base
    self.table_name = 'spree_wallet_payment_sources'
  end

  def up
    credit_cards = CreditCard.
      where.not(gateway_customer_profile_id: nil).
      where.not(user_id: nil)

    credit_cards.find_each do |credit_card|
      WalletPaymentSource.find_or_create_by!(
        user_id: credit_card.user_id,
        payment_source_id: credit_card.id,
        payment_source_type: 'Spree::CreditCard'
      ) do |wallet_source|
        wallet_source.default = credit_card.default
      end
    end
  end

  def down
  end
end

# touched on 2025-05-22T19:23:25.617377Z
# touched on 2025-06-13T21:17:37.852732Z