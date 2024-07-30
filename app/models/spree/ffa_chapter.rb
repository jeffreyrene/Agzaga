module Spree
  class FfaChapter < Spree::Base

    has_many :orders

    self.whitelisted_ransackable_attributes = %w[name school_name created_at]

    scope :sort_by_sub_total_asc, lambda { order("sub_total ASC") }
    scope :sort_by_sub_total_desc, lambda { order("sub_total DESC") }
    scope :sort_by_orders_count_asc, lambda { order("orders_count ASC") }
    scope :sort_by_orders_count_desc, lambda { order("orders_count DESC") }

    validates :first_name, :last_name, :phone_number, presence: true, if: :state_completed_or_user?
    validates :first_name, :last_name, format: {with: /\A[^0-9`!@#\$%\^&*+_=]+\z/}, if: :state_completed_or_user?
    validates :phone_number, format: { with: /\A\(?\d{3}\)?[- ]?\d{3}[- ]?\d{4}\z/,
    message: "Invalid, It should be in the format XXX-XXX-XXXX"}, if: :state_completed_or_user?
    validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, if: :state_completed_or_user?

    validates :name, :members, :number, :ein_number, presence: true, if: :state_completed_or_chapter?
    validates :ein_number,format: { with: /\A(?:\d{2})?\)?[- ]?\d{7}\z/, message: "Invalid, It should be in the format XX-XXXXXXX"},
    if: :state_completed_or_chapter?
    validates :members, numericality: { only_integer: true, greater_than: 0 }, if: :state_completed_or_chapter?

    validates :school_name, :city, :state, :postal_code, :street, presence: true, if: :state_completed_or_school?
    validates :city, :state, format: {with: /\A[^0-9`!@#\$%\^&*+_=]+\z/}, if: :state_completed_or_school?
    validates :postal_code, length: { maximum: 5 }
    validates :digital_signature, presence: true, format: {with: /\A[^0-9`!@#\$%\^&*+_=]+\z/}, if: :state_completed_or_signature?

    def completed?
      status == 'completed'
    end

    def state_completed_or_user?
      status.include?('user') || completed? if status != nil
    end

    def state_completed_or_chapter?
      status.include?('chapter') || completed? if status != nil
    end

    def state_completed_or_school?
      status.include?('school') || completed? if status != nil
    end

    def state_completed_or_signature?
      status.include?('signature') || completed? if status != nil
    end

    def approved_states
      approved_states = ["AR", "FL", "IA", "IN", "KY", "KS", "LA", "MI", "MN", "MO", "MS", "ND", "NE", "OH", "OK", "PA", "SD", "TX", "VA"]
    end

    def full_name
      [first_name, last_name].select(&:present?).join(' ').titleize
    end
  end
end

# touched on 2025-05-22T19:22:05.373677Z
# touched on 2025-05-22T22:37:09.105600Z
# touched on 2025-05-22T22:54:45.632408Z
# touched on 2025-05-22T23:46:53.729004Z
# touched on 2025-05-22T23:47:23.550655Z
# touched on 2025-06-13T21:18:19.538948Z