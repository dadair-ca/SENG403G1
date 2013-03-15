SENG403G1::Application.routes.draw do
  devise_for :users

#  match 'rentals/:id/new' => 'rentals#new', :via => :get
#  get 'rentals/:id/new' => 'rentals#new', :as => :new_physical_rental
  resources :rentals do
    resources :mailers, :only => [:new, :create], :path_names => { :new => 'overdue', :create => 'send' } do
      post :create => "mailers#create", :as => :create, :path => :new, :on => :collection
    end
  end

  resources :users
  resources :authors
 
  
  match 'items/search' => 'items#search'
  match 'items/advance' => 'items#adv_search'
  match 'items/results' => 'items#results'
  match 'items/advresults' => 'items#advresults'
  resources :items do
    resources :physical_items
  end

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

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  #root :to => 'items#index'
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  match ':not_found' => redirect('/'), :constraints => { :not_found => /.*/ }
end
