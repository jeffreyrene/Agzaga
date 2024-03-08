module Spree
  class User < Spree::Base
    include UserMethods

    devise :database_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable, :encryptable, :omniauthable,
           omniauth_providers: [:google_oauth2]
    devise :confirmable if Spree::Auth::Config[:confirmable]

    has_many :save_items, class_name: 'Spree::SaveItem'

    def self.ransackable_scopes(_auth_object = nil)
      %i(with_discarded)
    end

    def has_save_item?(object)
      save_items.exists?(variant_id: object.variant.id)
    end

    if defined?(Spree::SoftDeletable)
      include Spree::SoftDeletable
    else
      acts_as_paranoid
      include Spree::ParanoiaDeprecations

      include Discard::Model
      self.discard_column = :deleted_at
    end

    after_destroy :scramble_email_and_password
    after_discard :scramble_email_and_password

    def password=(new_password)
      generate_spree_api_key if new_password.present? && spree_api_key.present?
      super
    end

    before_validation :set_login

    scope :admin, -> { includes(:spree_roles).where("#{Role.table_name}.name" => "admin") }

    def self.admin_created?
      User.admin.count > 0
    end

    def admin?
      has_spree_role?('admin')
    end

    def confirmed?
      !!confirmed_at
    end

    protected

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
      end
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

    private

    def set_login
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.login ||= email if email
    end

    def scramble_email_and_password
      return true if destroyed?

      self.email = SecureRandom.uuid + "@example.net"
      self.login = email
      self.password = SecureRandom.hex(8)
      self.password_confirmation = password
      save
    end
  end
end

# touched on 2025-05-22T20:44:19.126691Z
# touched on 2025-05-22T23:07:03.432285Z
# touched on 2025-05-22T23:22:50.149922Z
# touched on 2025-05-22T23:46:22.432170Z
# touched on 2025-06-13T21:15:57.529671Z