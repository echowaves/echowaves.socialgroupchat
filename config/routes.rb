Echowaves::Application.routes.draw do
  
  devise_for :users

  resources :users, :only => [:index, :show] do
    resources :subscriptions, :only => [:index]
    member do
      put :follow
      put :unfollow
    end
  end
  
  resources :convos, :only => [:index, :show, :new, :create] do
    member do
      # FIXME: should be post, not get
      put :subscribe
      put :unsubscribe
    end
    # nested message, essential to support restful resources for messages
    resources :messages, :only => [:index, :show, :create]
    resources :users, :controller => :convo_users, :except => [:edit, :show, :update] do
      get :manage, :on => :collection
    end
  end
  
  resources :visits, :only => [:index]

  root :to => "welcome#index"
  match '/welcome', :to => 'welcome#index', :as => :welcome
  match '/updates', :to => 'users#updated_subscriptions'

  resource :socket, :only => [:subscribe, :unsubscribe] do
    member do
      post :subscribe
      post :unsubscribe
    end
  end

  


end
