Spree::Core::Engine.add_routes do
  namespace :admin, path: Spree.admin_path do
    root to: "dashboard#show"

    # Addresses
    resources :addresses do
      collection do
        post :update_country
      end
    end

    # Authentication
    resources :oauth_applications

    # Countries
    resources :countries, except: [:show] do
      resources :states, except: [:index, :show]
    end

    # Classifications
    patch :classification, path: "classification/taxon/:taxon_id/product/:product_id", to: "classifications#update"

    # CMS Pages
    resources :cms_pages do
      collection do
        get :filter
      end
      member do
        patch :update_visibility
      end

      resources :cms_sections, except: [:index] do
        member do
          patch :update_position
        end
      end
    end

    # Dashboard
    resource :dashboard, only: [:show]

    # Error forbidden
    get "/forbidden", to: "errors#forbidden", as: :forbidden

    # Menus
    resources :menus do
      resources :menu_items, except: :index do
        member do
          patch :reposition
          delete :remove_icon
        end
      end
    end

    # Options
    resources :option_types do
      resources :option_values, except: :index
    end

    # Orders
    resources :orders, except: [:show] do
      collection do
        get :filter
      end

      member do
        get :channel
        get :new_bill_address
        get :new_ship_address
        get :add_customer_email
        get :new_customer
        get :existing_customer
        post :resend
        put :open_adjustments
        put :close_adjustments
        put :approve
        put :cancel
        put :resume
        put :set_channel
        put :reset_digitals
        put :reset_customer_details
      end

      resources :customer_returns, only: [:index, :new, :edit, :create, :update] do
        member do
          put :refund
        end
      end

      resources :adjustments
      resources :return_authorizations do
        member do
          put :cancel
        end
      end

      resources :payments do
        member do
          put :fire
        end

        resources :log_entries
        resources :refunds, only: [:new, :create, :edit, :update]
      end

      resources :reimbursements, only: [:index, :create, :show, :edit, :update] do
        member do
          post :perform
        end
      end
    end

    # Payment Methods
    resources :payment_methods

    # Products
    resources :products do
      collection do
        get :filter
        patch :bulk_update_status
      end
      member do
        post :update_availability
        post :update_cost_currency
        post :update_promotionable
        patch :remove_from_taxon
        post :clone
        get :add_stock, path: "/add_stock/:variant_id"
      end

      resources :digitals, only: [:index, :create, :destroy]
      resources :images
      resources :prices, only: [:index, :create]
      resources :product_properties do
        collection do
          get :prototypes
          post :prototype_properties
        end
      end
      resources :variants
      resources :variants_including_master, only: [:update]
    end

    # Properties
    resources :properties do
      collection do
        get :filtered
      end
    end

    # Prototypes
    resources :prototypes do
      collection do
        get :available
      end

      member do
        post :select
      end
    end

    # Promotions
    resources :promotions do
      collection do
        get :filter
      end

      member do
        post :clone
      end

      resources :promotion_rules
      resources :promotion_actions
    end
    resources :promotion_categories, except: [:show]

    # Returns
    get "/return_authorizations", to: "returns#return_authorizations", as: :return_authorizations
    get "/customer_returns", to: "returns#customer_returns", as: :customer_returns
    resources :return_items, only: [:update]

    # Reports
    resources :reports, only: [:index] do
      collection do
        get :sales_total
        post :sales_total
      end
    end

    # Roles
    resources :roles

    # Refunds
    resources :reimbursement_types
    resources :refund_reasons, except: :show
    resources :return_authorization_reasons, except: :show

    # Search
    resources :search

    # Shipping
    resources :shipping_methods
    resources :shipping_categories
    resources :shipments do
      member do
        %w[ready ship cancel resume pend].each do |state|
          patch state.to_sym
        end
        get :edit_tracking_number
        patch :add_item
        patch :remove_item
        patch :increment_item
        patch :transfer_to_location
        patch :transfer_to_shipment
      end
    end

    # Stores
    resources :stores, except: %i[index show]

    # States
    resources :states

    # Stock
    resources :stock_transfers, only: [:index, :show, :new, :create]
    resources :stock_locations do
      resources :stock_movements, except: [:edit, :update, :destroy]
      collection do
        post :transfer_stock
      end
    end
    resources :stock_items, only: [:create, :update, :destroy]

    # Store Credit
    resources :store_credit_categories

    # Tax
    resources :tax_rates
    resources :tax_categories

    # Taxonomies / Taxons
    resources :taxonomies do
      resources :taxons do
        member do
          patch :reposition
          delete :remove_icon
        end
      end
    end
    resources :taxons, only: [:index, :show] do
      collection do
        post :products_panel
      end
    end

    # Users
    resources :users do
      collection do
        get :filter
      end

      member do
        get :addresses
        get :customer_details
        put :update_address
        get :orders
      end

      resources :store_credits
    end

    # Webhooks
    resources :webhooks_subscribers

    # Zones
    resources :zones
  end

  get Spree.admin_path, to: "admin/dashboard#show", as: :admin
end
