# == Route Map
#
#                     Prefix Verb   URI Pattern                                           Controller#Action
#                  positions GET    /positions(.:format)                                  positions#index
#                            POST   /positions(.:format)                                  positions#create
#               new_position GET    /positions/new(.:format)                              positions#new
#              edit_position GET    /positions/:id/edit(.:format)                         positions#edit
#                   position GET    /positions/:id(.:format)                              positions#show
#                            PATCH  /positions/:id(.:format)                              positions#update
#                            PUT    /positions/:id(.:format)                              positions#update
#                            DELETE /positions/:id(.:format)                              positions#destroy
#                 strategies GET    /strategies(.:format)                                 strategies#index
#                            POST   /strategies(.:format)                                 strategies#create
#               new_strategy GET    /strategies/new(.:format)                             strategies#new
#              edit_strategy GET    /strategies/:id/edit(.:format)                        strategies#edit
#                   strategy GET    /strategies/:id(.:format)                             strategies#show
#                            PATCH  /strategies/:id(.:format)                             strategies#update
#                            PUT    /strategies/:id(.:format)                             strategies#update
#                            DELETE /strategies/:id(.:format)                             strategies#destroy
#                      users GET    /users(.:format)                                      users#index
#                            POST   /users(.:format)                                      users#create
#                   new_user GET    /users/new(.:format)                                  users#new
#                  edit_user GET    /users/:id/edit(.:format)                             users#edit
#                       user GET    /users/:id(.:format)                                  users#show
#                            PATCH  /users/:id(.:format)                                  users#update
#                            PUT    /users/:id(.:format)                                  users#update
#                            DELETE /users/:id(.:format)                                  users#destroy
# positions_refreshpositions GET    /positions/refreshpositions(.:format)                 positions#refreshpositions
#             documents_main GET    /documents/main(.:format)                             documents#main
#                            GET    /auth/:provider/callback(.:format)                    sessions#callback
#                     logout DELETE /logout(.:format)                                     sessions#destroy
#        children_strategies GET    /strategies/children(.:format)                        strategies#children
#             paint_strategy GET    /strategies/:id/paint(.:format)                       strategies#paint
#              copy_strategy POST   /strategies/:id/copy(.:format)                        strategies#copy
#         strategy_positions POST   /strategies/:strategy_id/positions(.:format)          positions#create
#     edit_strategy_position GET    /strategies/:strategy_id/positions/:id/edit(.:format) positions#edit
#          strategy_position PATCH  /strategies/:strategy_id/positions/:id(.:format)      positions#update
#                            PUT    /strategies/:strategy_id/positions/:id(.:format)      positions#update
#                            DELETE /strategies/:strategy_id/positions/:id(.:format)      positions#destroy
#                            GET    /strategies(.:format)                                 strategies#index
#                            POST   /strategies(.:format)                                 strategies#create
#                            GET    /strategies/new(.:format)                             strategies#new
#                            GET    /strategies/:id/edit(.:format)                        strategies#edit
#                            GET    /strategies/:id(.:format)                             strategies#show
#                            PATCH  /strategies/:id(.:format)                             strategies#update
#                            PUT    /strategies/:id(.:format)                             strategies#update
#                            DELETE /strategies/:id(.:format)                             strategies#destroy
#                            GET    /users(.:format)                                      users#index
#                            POST   /users(.:format)                                      users#create
#                            GET    /users/:id/edit(.:format)                             users#edit
#                            PATCH  /users/:id(.:format)                                  users#update
#                            PUT    /users/:id(.:format)                                  users#update
#                            DELETE /users/:id(.:format)                                  users#destroy
#                       root GET    /                                                     users#index
#                            GET    /*path(.:format)                                      application#error_404
#

MyPosi::Application.routes.draw do
  # resources :positions
  # resources :strategies
  # resources :users

  match 'positions/refreshpositions', :to => 'positions#refreshpositions', via: 'get'
  match 'documents/main', :to => 'documents#main', via: 'get'
#  match 'strategies/:strategy_id(.:format)/paint', :to => 'strategies#paint'
#  match 'strategies/:strategy_id(.:format)/graph', :to => 'strategies#graph', via: :get
  match '/auth/:provider/callback' => 'sessions#callback', via: 'get'
  match '/logout' => 'sessions#destroy', :as => :logout, via: 'delete'
  resources :strategies, :except => ["new"] do
    collection do
      get :children
    end
    member do
      get :paint
      post :copy
    end
    resources :positions, :only => ["destroy", "update", "create", "edit"]
  end
  resources :users, :only => ["index", "edit", "update", "destroy"]

  root 'users#index'
#  root :to => "users#index", via: [:get]
  match '*path', :to => 'application#error_404', via: 'get'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
end
