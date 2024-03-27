class Spree::Order < Spree::Base
  has_many :email_logs
  belongs_to :ffa_chapter, optional: true

  before_validation :assign_shipping_to_billing_address, if: :use_shipping?
  attr_accessor :use_shipping

  self.whitelisted_ransackable_attributes += %w[utm_source ref tar]

  def credit_total
    self.reimbursements.sum { |reimbursement| reimbursement.credits.sum(:amount) }
  end

  def outstanding_balance
    if state == 'canceled'
      -1 * payment_total
    else
      total - reimbursement_total - payment_total + credit_total
    end
  end

  def add_store_credit_payments
    return if user.nil?
    return if payments.store_credits.checkout.empty? && user.available_store_credit_total(currency: currency).zero?

    payments.store_credits.checkout.each(&:invalidate!)

    # this can happen when multiple payments are present, auto_capture is
    # turned off, and one of the payments fails when the user tries to
    # complete the order, which sends the order back to the 'payment' state.
    authorized_total = payments.pending.sum(:amount)

    remaining_total = outstanding_balance - authorized_total

    matching_store_credits = user.store_credits.where(currency: currency)

    if matching_store_credits.any?
      payment_method = Spree::PaymentMethod::StoreCredit.first

      required_credit = self.store_credit_request

      matching_store_credits.order_by_priority.each do |credit|
        break if remaining_total.zero? || required_credit.zero?
        next if credit.amount_remaining.zero?

        amount_to_take = [credit.amount_remaining, required_credit].min

        payments.create!(source: credit,
                         payment_method: payment_method,
                         amount: amount_to_take,
                         state: 'checkout',
                         response_code: credit.generate_authorization_code)
        remaining_total -= amount_to_take
        required_credit -= amount_to_take
      end
    end

    other_payments = payments.checkout.not_store_credits

    if remaining_total.zero?
      other_payments.each(&:invalidate!)
    elsif other_payments.size == 1
      other_payments.first.update!(amount: remaining_total)
    end

    payments.reset

    if payments.where(state: %w(checkout pending completed)).sum(:amount) != total
      errors.add(:base, I18n.t('spree.store_credit.errors.unable_to_fund')) && (return false)
    end
  end

  def total_applicable_store_credit
    if can_complete? || complete?
      valid_store_credit_payments.to_a.sum(&:amount)
    else
      [total, (user.try(:available_store_credit_total, currency: currency) || 0.0)].min
    end
  end

  def assign_default_user_addresses
    if user
      bill_address = user.bill_address
      ship_address = user.ship_address
      # this is one of 2 places still using User#bill_address
      self.bill_address ||= bill_address if bill_address.try!(:valid?)
      # Skip setting ship address if order doesn't have a delivery checkout step
      # to avoid triggering validations on shipping address
      self.ship_address ||= ship_address if ship_address.try!(:valid?) && checkout_steps.include?("payment")
    end
  end

  def create_proposed_shipments
    if completed?
      raise CannotRebuildShipments.new(I18n.t('spree.cannot_rebuild_shipments_order_completed'))
    elsif shipments.any? { |shipment| !shipment.pending? }
      raise CannotRebuildShipments.new(I18n.t('spree.cannot_rebuild_shipments_shipments_not_pending'))
    else
      shipments.destroy_all
      shipments.push(*Spree::Config.stock.coordinator_class.new(self).shipments)
    end
  end

  def ensure_updated_shipments
    if !completed? && shipments.all?(&:pending?)
      shipments.destroy_all
      update_column(:shipment_total, 0)
      self.recalculate
      restart_checkout_flow
    end
  end


  def billing_eq_shipping_address?
    ship_address == bill_address
  end

  def persist_user_address!
    if !temporary_address && user && user.respond_to?(:persist_order_address) && bill_address_id
      user.persist_order_address(self)
    end
  end

  def add_payment_sources_to_user_wallet
    Spree::Config.
      add_payment_sources_to_wallet_class.new(self).
      add_card_to_wallet
  end

  def remove_payment_sources_to_wallet(id)
    Spree::Config.
      add_payment_sources_to_wallet_class.new(self).
      remove_from_wallet(id)
  end

  def five_percent_of_items_total
    '%.2f' % (item_total.to_f*0.05)
  end

  def assign_shipping_to_billing_address
    self.bill_address = ship_address if ship_address
    true
  end

  private

  def use_shipping?
    use_shipping.in?([true, 'true', '1'])
  end
end

# touched on 2025-05-22T22:55:54.516324Z
# touched on 2025-06-13T21:16:07.727029Z