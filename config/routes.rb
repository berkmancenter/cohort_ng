CohortNg::Application.routes.draw do

  post "importer/upload_file"
  get "importer/index"
  get "importer/", :controller => :importer, :action => :index
  get "importer/import" 
  
  resources :importer do
    collection do
      get :upload
    end
  end 

  get "document_query/new"
  get "document_query/recent"
  get "document_query/yours"
  get "document_query/contact"

  get "search/index"
  get "search/contacts"
  get "search/notes"
  get "search/tags"
  get "search/documents"
  
  resources :search do
    collection do
      get :advanced
    end
  end

  resources :saved_searches

  get "contact_cart_query/yours"
  get "contact_cart_query/all"
  get "contact_cart_query/new"
  get "contact_cart_query/recent"
  get "contact_cart_query/your_private"
  get "contact_cart_query/chooser"

  resources :contact_carts do
    collection do
      post :add_group
    end
    
    member do
      post :add_object
      get :contacts
      get :tags
      get :saved_searches
      post :remove_contact
      get :search
    end
  end

  match 'tag_query/tag/:id' => 'tag_query#tag'
  get "tag_query/search"
  get "tag_query/recent_taggings"

  resources :tags do
    collection do
      get :display
    end
    
    member do
      get :children
      post :merge
      get :controls
      get :related
    end 
  end
  
  get 'tags/:id', :controller => :tags, :action => :show, :as => 'acts_as_taggable_on_tag'

  resources :contact_sources

  get "note_query/new"
  get "note_query/upcoming"
  get "note_query/all_upcoming"
  get "note_query/priority"
  get "note_query/yours"
  get "note_query/recent"

  match 'note_query/contact/:id' => 'note_query#contact', :as => 'note_query_contact'
  match 'note_query/contact_tasks/:id' => 'note_query#contact_tasks', :as => 'note_query_contact_tasks'

  resources :documents

  resources :log_items

  resources :notes do
    collection do
      get :tasks
    end
  end

  resources :addresses

  resources :emails

  get "contact_query/recent"
  get "contact_query/yours"
  get "contact_query/new"
  get "contact_query/all"
  get "contact_query/todo"
  get "contact_query/search"
  get "contact_query/tag_contacts/:id", :controller => :contact_query, :action => :tag_contacts
  get "contact_query/similar_names/:id", :controller => :contact_query, :action => :similar_names
  get "contact_query/tag_contacts_by_name/:id", :controller => :contact_query, :action => :tag_contacts_by_name

  get "base/index"

  match 'contact_query/autocomplete_tags' => 'contact_query#autocomplete_tags'

  resources :contacts do
    collection do
      get :quick
    end
  end    

  devise_for :users
  
  resources :users

  root :to => "base#index"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
