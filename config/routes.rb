Echowaves::Application.routes.draw do
  
  devise_for :users

  resources :users, :only => [:index, :show] do
    resources :subscriptions, :only => [:index]
    resources :followerships, :only => [:create, :destroy]
  end
  
  resources :convos, :only => [:index, :show, :new, :create] do
    # nested message, essential to support restful resources for messages
    resources :messages, :only => [:index, :show, :create]
    resources :users, :controller => :convo_users, :except => [:edit, :show, :update] do
      get :manage, :on => :collection
    end
    resources :subscriptions, :only => [:create, :destroy]
    
  end
  
  resources :visits, :only => [:index]
  resources :updates, :only => [:index]

  root :to => "welcome#index"
  match '/welcome', :to => 'welcome#index', :as => :welcome

  resource :socket, :only => [:subscribe, :unsubscribe] do
    member do
      # FIXME: replace with create/delete
      post :subscribe
      post :unsubscribe
    end
  end

  


end
