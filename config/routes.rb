Rails.application.routes.draw do
  # Root path - redirect to feed if logged in, otherwise show landing page
  root 'feed#index'

  # Authentication routes
  get '/signup', to: 'users#new', as: 'signup'
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

  # User routes
  resources :users, only: [:create, :show, :edit, :update] do
    member do
      get :following
      get :followers
    end
    # Follow/unfollow actions
    post '/follow', to: 'follows#create', as: 'follow'
    delete '/unfollow', to: 'follows#destroy', as: 'unfollow'
  end

  # Recommendations routes
  resources :recommendations do
    # Nested routes for likes and comments
    post '/like', to: 'likes#create', as: 'like'
    resources :comments, only: [:create, :destroy]
  end

  # Feed route
  get '/feed', to: 'feed#index', as: 'feed'

  # Old cars routes (keep for backwards compatibility)
  resources :cars
end
