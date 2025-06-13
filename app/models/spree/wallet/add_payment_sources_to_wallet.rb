# frozen_string_literal: true

# This class is responsible for saving payment sources in the user's "wallet"
# for future use.  You can substitute your own class via
# `Spree::Config.add_payment_sources_to_wallet_class`.
class Spree::Wallet::AddPaymentSourcesToWallet
  def initialize(order)
    @order = order
  end

  # This is called after an order transistions to complete and should save the
  # order's payment source in the user's "wallet" for future use.
  #
  # @return [void]
  def add_to_wallet
    if !order.temporary_payment_source && order.user
      # select valid sources
      payments = order.payments.valid
      sources = payments.map(&:source).
        uniq.
        compact.
        select { |payment| payment.try(:reusable?) }

      # add valid sources to wallet and optionally set a default
      if sources.any?
        # arbitrarily sort by id for picking a default
        sources.sort_by(&:id).each do |source|
          order.user.wallet.add(source)
        end

        make_default
        order.save!
      end
    end
  end

  def add_card_to_wallet
    if !order.temporary_payment_source && order.user
      payments = order.payments
      sources = payments.map(&:source).
        uniq.
        compact.
        select { |payment| payment.try(:reusable?) }
      order.user.wallet.add(sources.sort_by(&:id).last) if sources.present?
      make_default
      @order.update(state: "payment") unless @order.state == 'complete'
      order.save!
    end
  end

  def remove_from_wallet(id)
    if !order.temporary_payment_source && order.user
      order.user.wallet_payment_sources.each do |source|
        if source.id == id
          source.delete
        end
      end
      @order.update(state: "payment")
      order.save!
    end
  end

  protected

  def make_default
    order.user.wallet.default_wallet_payment_source = order.user.wallet_payment_sources.last
  end

  private

  attr_reader :order
end

# touched on 2025-05-22T19:23:25.621720Z
# touched on 2025-05-22T20:32:57.249971Z
# touched on 2025-05-22T22:44:54.841917Z
# touched on 2025-05-22T23:41:22.557368Z
# touched on 2025-06-13T21:19:19.275113Z