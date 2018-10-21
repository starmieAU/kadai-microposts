Rails.application.routes.draw do
  root to: 'toppages#index'
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create] do
    member do
      get :followings
      get :followers
      get :likes
    end
  end

  resources :microposts, only: [:create, :destroy]
  
  resources :follow_relations, only: [:create, :destroy]
  resources :user_microposts, only: [:create, :destroy]
end
