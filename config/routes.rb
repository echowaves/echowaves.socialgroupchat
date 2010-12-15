Echowaves::Application.routes.draw do
  resources :convos, :only => [:index, :show, :new, :create] do
    member do
      # FIXME: should be post, not get
      get 'subscribe'
      get 'unsubscribe'
    end
    # nested message, essential to support restful resources for messages
    resources :messages, :only => [:index, :show, :create]
    resources :users, :controller => :convo_users, :except => [:edit, :show, :update] do
      get :manage, :on => :collection
    end
  end

  devise_for :users

  resources :users, :only => [:index, :show] do
    resources :subscriptions, :only => [:index]
  end


  match 'welcome', :to => 'welcome#index', :as => :welcome
  root :to => "welcome#index"

  resource :socket do
    member do
      post :subscribe
      post :unsubscribe
    end
  end

end
