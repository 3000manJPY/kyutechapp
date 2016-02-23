Rails.application.routes.draw do
  get 'info/index'

  resources :notices
  #namespace :api do
  #  namespace :v1 do
 
#  get 'api/v1/lectures' => 'api/v1/lectures#index'
   get    '/api/v2/lectures'                      => 'api/v2/lectures#index'

   get    '/api/v1/notices'                      => 'api/v1/notices#index'
   get    '/api/v2/notices'                      => 'api/v2/notices#notices'
   get    '/api/v2/notices/:id'                      => 'api/v2/notices#twitter'

   get    '/api/v1/notices/new'                      => 'api/v1/notices#new'
   get	  'api/v2/notices/redirect/:id'		=> 'api/v2/notices#redirect'
   get	  'api/v2/notices/web/:id'		=> 'api/v2/notices#webPage'
   get	  'api/v2/accesses'		=> 'api/v2/access#show'
   #   resources :lectures
   #   resources :lectures
  #root :to => "static#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'info#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
#   end
#  end
end
