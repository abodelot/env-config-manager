Rails.application.routes.draw do
  resources :variables

  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :environments do
    resources :variables
    resources :users
    member do
      post :adduser
      post :addvars
      delete :deluser
    end
  end

  root 'environments#index'

  resources :users
  resources :variables
  resource :version, :controller => 'version'

end
