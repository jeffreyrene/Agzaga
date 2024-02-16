  # Configure Solidus Preferences
# See http://docs.solidus.io/Spree/AppConfiguration.html for details

Spree.config do |config|
  # Core:

  # Default currency for new sites
  config.currency = "USD"

  # from address for transactional emails
  config.mails_from = "store@example.com"

  # Use combined first and last name attribute in HTML views and API responses
  config.use_combined_first_and_last_name_in_address = true

  # Use legacy Spree::Order state machine
  config.use_legacy_order_state_machine = false

  # Use the legacy address' state validation logic
  config.use_legacy_address_state_validator = false

  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false

  # When set, product caches are only invalidated when they fall below or rise
  # above the inventory_cache_threshold that is set. Default is to invalidate cache on
  # any inventory changes.
  # config.inventory_cache_threshold = 3

  # Enable Paperclip adapter for attachments on images and taxons
  config.image_attachment_module = 'Spree::Image::PaperclipAttachment'
  config.taxon_attachment_module = 'Spree::Taxon::PaperclipAttachment'

  # Disable legacy Solidus custom CanCanCan actions aliases
  config.use_custom_cancancan_actions = false

  # Defaults

  # Set this configuration to `true` to raise an exception when
  # an order is populated with a line item with a mismatching
  # currency. The `false` value will just add a validation error
  # and will be the only behavior accepted in future versions.
  # See https://github.com/solidusio/solidus/pull/3456 for more info.
  config.raise_with_invalid_currency = false

  # Set this configuration to false to always redirect the user to
  # /unauthorized when needed, without trying to redirect them to
  # their previous location first.
  config.redirect_back_on_unauthorized = true

  # Set this configuration to `true` to allow promotions
  # with no associated actions to be considered active for use by customers.
  # See https://github.com/solidusio/solidus/pull/3749 for more info.
  config.consider_actionless_promotion_active = false

  # Set this configuration to `false` to avoid running validations when
  # updating an order. Be careful since you can end up having inconsistent
  # data in your database turning it on.
  # See https://github.com/solidusio/solidus/pull/3645 for more info.
  config.run_order_validations_on_order_updater = true

  # Permission Sets:

  # Uncomment and customize the following line to add custom permission sets
  # to a custom users role:
  # config.roles.assign_permissions :role_name, ['Spree::PermissionSets::CustomPermissionSet']


  # Frontend:

  # Custom logo for the frontend
  # config.logo = "logo/solidus.svg"

  # Template to use when rendering layout
  # config.layout = "spree/layouts/spree_application"


  # Admin:

  # Custom logo for the admin
  config.admin_interface_logo = "agzaga_logo_black.svg"

  # Gateway credentials can be configured statically here and referenced from
  # the admin. They can also be fully configured from the admin.
  #
  # Please note that you need to use the solidus_stripe gem to have
  # Stripe working: https://github.com/solidusio-contrib/solidus_stripe
  #
  config.static_model_preferences.add(
    Spree::PaymentMethod::StripeCreditCard,
    'stripe_env_credentials',
    secret_key: ENV['STRIPE_SECRET_KEY'],
    publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
    server: ENV['STRIPE_MODE'] != 'test' && Rails.env.production? ? 'production' : 'test',
    test_mode: ENV['STRIPE_MODE'] == 'test',
    stripe_country: 'US',
    v3_elements: false,
    v3_intents: true
  )

  config.static_model_preferences.add(
    SolidusAffirmV2::PaymentMethod,
    'affirm_env_credentials',
    public_api_key: ENV['AFFIRM_PUBLIC_KEY'],
    private_api_key: ENV['AFFIRM_PRIVATE_KEY'],
    javascript_url: ENV['AFFIRM_JS_RUNTIME_URL'],
    test_mode: !Rails.env.production?
  )

  config.static_model_preferences.add(
    SolidusPaypalCommercePlatform::PaymentMethod,
      'paypal_commerce_platform_credentials', {
      test_mode: !Rails.env.production?,
      client_id: ENV['PAYPAL_CLIENT_ID'],
      client_secret: ENV['PAYPAL_CLIENT_SECRET'],
      display_on_product_page: true,
      display_on_cart: true,
      venmo_standalone: 'disabled'
    }
  )
end

Spree::PermittedAttributes.address_attributes << [:firstname, :lastname, :businessname]
Spree::PermittedAttributes.checkout_address_attributes << {pick_up_person_attributes: [:id, :firstname, :lastname, :email]}
Spree::PermittedAttributes.checkout_address_attributes << [:use_shipping]
Spree::PermittedAttributes.shipment_attributes << [:tracking_lookup]
Spree::PermittedAttributes.taxon_attributes << [:small_ads, :large_ads, :video_link, :small_ads_end_at, :large_ads_end_at, :annotation, :small_ad_link, :large_ad_link, :small_ad_for_mobile, :large_ad_for_mobile]


Spree::Frontend::Config.configure do |config|
  config.locale = 'en'
end

Spree::Backend::Config.configure do |config|
  config.locale = 'en'

  # add product question in product sub items
  config.menu_items.detect { |menu_item|
    menu_item.label == :products
  }.sections << :product_questions

  # Uncomment and change the following configuration if you want to add
  # a new menu item:
  #
  # config.menu_items << config.class::MenuItem.new(
  #   [:section],
  #   'icon-name',
  #   url: 'https://solidus.io/'
  # )
  config.menu_items << config.class::MenuItem.new(
    [:contact],
    'users',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_contacts_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:net_suite_logs_main],
    'star',
    condition: -> { can?(:admin, :dashboards) },
    partial: 'spree/admin/shared/net_suite_sub_menu',
    url: :admin_net_suite_logs_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:ebay_logs],
    'star',
    condition: -> { can?(:admin, :dashboards) },
    partial: 'spree/admin/shared/ebay_sub_menu',
    url: :admin_ebay_logs_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:facebook_api_logs],
    'exclamation-triangle',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_facebook_api_logs_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:cta_images],
    'star',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_cta_images_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:net_suite_authorization],
    'certificate',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_net_suite_auth_index_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:home_page_review],
    'star',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_home_page_reviews_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:deals_page],
    'star',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_deals_page_index_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:email_logs],
    'star',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_email_logs_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:ffa],
    'database',
    condition: -> { can?(:admin, :dashboards) },
    partial: 'spree/admin/shared/ffa_sub_menu',
    url: :admin_ffa_chapter_enrollments_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:help_center],
    'star',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_help_centers_path
  )

  config.menu_items << config.class::MenuItem.new(
    [:chuckwagon_contest],
    'database',
    condition: -> { can?(:admin, :dashboards) },
    url: :admin_store_credit_winners_path
  )
end


Spree::Api::Config.configure do |config|
  config.requires_authentication = true
end

# Required if using solidus_frontend
Spree::Config[:show_raw_product_description] = true

SpreeEditor::Config.tap do |config|
  config.ids = 'product_description product_features help_center_question help_center_answer page_body event_body taxon_annotation'

  # change the editor to CKEditor
  config.current_editor = 'CKEditor'
end

Spree.user_class = "Spree::LegacyUser"

# Rules for avoiding to store the current path into session for redirects
# When at least one rule is matched, the request path will not be stored
# in session.
# You can add your custom rules by uncommenting this line and changing
# the class name:
#
# Spree::UserLastUrlStorer.rules << 'Spree::UserLastUrlStorer::Rules::AuthenticationRule'

Rails.application.config.spree.stock_splitters = [
  Spree::Stock::Splitter::ShippingCategory
]
Spree::Auth::Config[:registration_step] = false

Rails.application.config.spree.calculators.shipping_methods << Spree::Calculator::Shipping::StandardShippingCalculator
Rails.application.config.spree.calculators.shipping_methods << Spree::Calculator::Shipping::ExpeditedShippingCalculator

Rails.application.config.spree.promotions.actions << 'Spree::Promotion::Actions::CreateShippingAdjustments'
Rails.application.config.spree.promotions.shipping_actions << 'Spree::Promotion::Actions::CreateShippingAdjustments'

Spree::Core::Environment::Calculators.add_class_set(:promotion_actions_create_shipping_adjustments)

Rails.application.config.spree.calculators.promotion_actions_create_shipping_adjustments = %w[
  Spree::Calculator::Shipping::ShippingDiscountCalculator
]


# touched on 2025-05-22T19:22:31.452267Z
# touched on 2025-05-22T20:41:36.631384Z
# touched on 2025-05-22T22:32:52.118068Z
# touched on 2025-05-22T23:21:04.118013Z
# touched on 2025-05-22T23:22:47.593943Z
# touched on 2025-06-13T21:15:26.438079Z