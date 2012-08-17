Gift::Application.routes.draw do
  match 'admin' => "admin_users#new"
  resources :admin_users, :only => [:new, :create] do
    post 'log_in', :on => :collection
  end
  namespace :admin do
    resources   :home, :only=> [:index]
    resources   :admin_users
    resources   :users
    resources   :products do
      resources :variants
    end
    resources   :option_values
    resources   :option_types do
      resources :option_values
    end
    match 'home' => 'home#index'
  end
  
  match '/auth/:provider/callback' => 'authentications#create'  
  match 'oauth/redirect' => "oauth#redirect"
  resources :authentications  
  resources :products
  resources :wishlists do
    member do
      post 'add_variant/:variant_id' => "wishlists#add_variant"
      delete 'remove_variant/:variant_id' => "wishlists#remove_variant"
      post 'variant_id/:variant_id/:vote' => "wishlists#vote" #, :constraints => { vote: /true|false/ }
      post 'create_payments'
    end
    resources :payment_summaries, only: [] do
      member do
        get 'summary'
        put 'confirm'
      end
    end
  end
  resources :payments, only: [] do
    member do
      get 'pay'
      put 'credit_card_payment'
    end
  end
  root :to => 'products#index'
end
