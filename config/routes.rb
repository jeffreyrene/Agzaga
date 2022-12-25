Rails.application.routes.draw do
mount SolidusPaypalCommercePlatform::Engine, at: '/solidus_paypal_commerce_platform'
  # This line mounts Solidus's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Solidus relies on it being the default of "spree"
  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  authenticated :spree_user, ->(u) { u&.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Spree::Core::Engine, at: '/'
  get '/export', to: 'spree/admin/products#export'
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  get '/export_interested_chapters', to: 'spree/admin/interested_chapters#export'
  get '/export_ffa_chapter_enrollments', to: 'spree/admin/ffa_chapter_enrollments#export'
  get '/export_ffa_fundraiser', to: 'spree/admin/ffa_fundraiser_calculations#export'
  post '/ebay_webhook', to: 'ebay_webhook#get_data'
  #get '/ebay_token', to: 'ebay_webhook#token_callback'

  resource :news_letter, only: [:create], defaults: { format: 'js' }

  Spree::Core::Engine.routes.draw do
    resources :stock_updates, only: [:new, :create]
    devise_scope :spree_user do
      post 'user_registration', to: 'user_sessions#user_registration'
      post 'forget_password', to: 'user_sessions#forget_password'
    end

    devise_for :spree_user,class_name: Spree.user_class, only: [:omniauth_callbacks], controllers: { omniauth_callbacks: 'spree/user_omniauth_callbacks' }

    namespace :admin do
      resources :product_questions, only: [:index, :destroy, :edit, :update] do
        member do
          get :publish
        end
      end
      resources :cta_images
      resources :contacts, only: [:index, :show]
      resources :labels
      resources :featured_products, only: [:index] do
        collection do
          post :update_positions
        end
      end

      resources :deals_products, only: [:index] do
        collection do
          post :update_deals_position
        end
      end
      resources :google_product_categories, only: [:index, :create]
      resources :bulk_update_product_prices, only: [:index, :create]
      resources :bulk_update_sale_prices, only: [:index, :create]
      resources :email_logs, only: [:index]
      resources :ffa_chapter_enrollments
      resources :change_logs, only: [:index]
      resources :ebay_change_logs, only: [:index]
      resources :ns_responses, only: [:index]
      resources :ffa_fundraiser_events, only: [:index, :create, :update]
      resources :help_centers do
        collection do
          post :update_positions
        end
      end
      resources :bulk_update_product_labels, only: [:index, :create]

      resources :tracking_lookups

      resources :labels_products, only: [:index] do
        collection do
          post :update_positions
        end
      end

      resources :store_credit_winners

      resources :ffa_fundraiser_calculations, only: [:index, :show]

      resources :facebook_api_logs, only: [:index] do
        collection do
          post :update_product_catalog
        end
      end

      resources :filter_types do
        collection do
          post :update_positions
          post :update_values_positions
        end
      end

      get '/products/:id/group_products', to: "products#group_products" , as: :group_products
      post '/products/:id/group_products', to: "products#add_group_products" , as: :add_group_products
      delete '/products/:id/group_products', to: "products#remove_group_product" , as: :remove_group_product
      post '/products/:id/add_on_product', to: "products#add_add_on_product" , as: :add_add_on_products
      get '/products/:id/add_on_product', to: "products#add_on_product" , as: :add_on_products
      delete '/products/:id/add_on_product', to: "products#remove_add_on_product" , as: :remove_add_on_product


      resources :home_page_reviews do
        collection do
          post :update_positions
        end
      end

      resources :cta_images do
        collection do
          post :update_positions
        end
      end

      delete '/filter_values/:id', to: "filter_values#destroy", as: :filter_value
      delete '/deals_page/:id/remove_image', to: "deals_page#remove_image" , as: :remove_image
      put '/deals_page/:id/edit_image', to: "deals_page#edit_image" , as: :edit_image
      get '/export_users_data', to: 'users#export'

      resources :deals_page
      resources :ebay_logs, only: [:index]
      resources :net_suite_logs, only: [:index]
      resources :net_suite_auth, only: [:index] do
        collection do
          get :consent_approved
        end
      end

      resources :interested_chapters, only: [:index, :edit, :update, :destroy]

      resources :products do
        member do
          get :bulk_update_variant_prices
        end
      end
    end

    resources :products do
      collection do
        get :deals
        get :gift_page
        get :product_reviews
        get :stock_update_notification
      end

      member do
        get :show_related
        get :reviews_form
        get :question_form
      end
    end

    resources :save_items, only: [:index, :create, :destroy]

    resources :product_categories, only: [:index, :show]
    resources :contacts, only: [:create, :new]
    resources :store_credit_winners, only: [:create, :new]

    resources :products, only: [] do
      resources :product_questions, only: %i[create new index update]
    end

    get '/product/id', to: 'products#quick_view', as: :quick_view
    get '/taxon_with_children', to: 'taxons#load_taxon_children', as: :load_taxon_children
    get '/update_upsell_modal', to: 'orders#update_upsell_modal'
    resources :taxon_options, only: [:index], defaults: { format: 'js' }
    resources :custom_hose_generator, only: [:index]
    delete '/cart/destroy_line_item', to: 'orders#destroy_line_item'
    get '/cart/increase_quantity', to: 'orders#increase_quantity'
    get '/cart/decrease_quantity', to: 'orders#decrease_quantity'
    get '/cart/update_line_item_quantity', to: 'orders#update_line_item_quantity'
    get '/', to: 'home#index_v2'
    get 'featured_products_cards', to: 'home#featured_products_cards'
    get 'best_seller_products_cards', to: 'home#best_seller_products_cards'
    get 'site_wide_products_cards', to: 'home#site_wide_products_cards'
    get 'recently_viewed_products_cards', to: 'home#recently_viewed_products_cards'
    get 'ffa_products_cards', to: 'ffa_home#ffa_products_cards'

    get '/faqs', to: 'pages#faq'
    get '/faqs_page', to: 'pages#faq_page'
    get '/privacy_policy', to: 'pages#privacy_policy'
    get '/mill', to: 'pages#mill'
    get '/shipping_policy', to: 'pages#shipping_policy'
    get '/about_us', to: 'pages#about_us'
    get '/freedom_wrap', to: 'pages#freedom_wrap'
    delete '/custom_hose_configuration', to: 'orders#destroy_custom_hose_from_line_items'
    delete '/remove_coupon', to: 'coupon_codes#remove_coupon'
    resources :ffa_fundraisers, path: :enroll
    patch 'update_chapter', to: 'checkout#update_chapter'
    post 'apply_shipment', to: 'checkout#apply_shipment_total'
    post 'remove_payment_source', to: 'checkout#remove_card_from_wallet'
    get '/august_event', to: 'pages#august_event'
    get '/populate_qty_modal', to: 'checkout#populate_qty_modal'
    get '/chuckwagon_dvd', to: 'pages#chuckwagon_dvd'
    get '/net_wraps', to: 'pages#net_wraps'
    get '/usa', to: 'pages#usa'
    get 'briddon_usa_flag_products_cards', to: 'pages#briddon_usa_flag_products_cards'
    get 'ariat_flag_products_cards', to: 'pages#ariat_flag_products_cards'
    get 'allied_flag_products_cards', to: 'pages#allied_flag_products_cards'
    get 'accessories_flag_products_cards', to: 'pages#accessories_flag_products_cards'
    get 'related_products_cards', to: 'products#related_products_cards'

    resources :e_signatures, only: [:new] do
      collection do
        post 'callbacks'
        get 'signature_url'
      end
    end

    resources :ffa_home, path: :ffa, only: [:index]
    resources :interested_chapters, only: [:create]
    resource :ns_products_data_sync, only: [:create]
    resource :paypal_tracking_number_sync, only: [:create]

    get '.well-known/apple-developer-merchantid-domain-association', to: 'stripe_apple_pay_verification_file#show'
  end
end

# touched on 2025-05-22T19:07:43.799619Z
# touched on 2025-05-22T19:22:39.718736Z
# touched on 2025-05-22T23:22:30.940362Z
# touched on 2025-05-22T23:47:31.584990Z
