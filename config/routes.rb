ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  map.root :controller => 'footprints', :action => 'index', :conditions => { :canvas => true }
  
  # This is the default route for hitting the app from the web
  map.root :controller => 'footprints', :action => 'web', :conditions => { :canvas => false }
  
  map.remove_user("remove_user", :controller => "admin", :action => "remove_user")
  
  map.resources :footprints
  
  map.ajax_create_footprint("ajax_create/:id", :controller => "footprints", :action => "ajax_create")
 
  map.friend_footprints("friends", :controller => "footprints", :action => "friends")
  map.recent_footprints("recent", :controller => "footprints", :action => "recent")
  
  
  map.invite_friends( "invite/friends", :controller => "admin", :action => "invite_friends")
  map.invited_friends( "invited/friends", :controller => "admin", :action => "invited_friends")

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
