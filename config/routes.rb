Gift::Application.routes.draw do

 


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end
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
#    match 'log_in' => "home#log_in"
    match 'home' => 'home#index'
  end
  
  match '/auth/:provider/callback' => 'authentications#create'  
  match 'oauth/redirect' => "oauth#redirect"
#  devise_for :users  
#  resources :projects  
#  resources :tasks
  resources :authentications  
  resources :products
  resources :wishlists
#  root :to => 'home#index'
  root :to => 'products#index'
#  
  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
