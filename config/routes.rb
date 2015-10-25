require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile/edit' }, controllers: { registrations: :registrations }
  root 'home#index'

  # page
  get :topic_filter, to: "home#topic_filter"
  get :category_filter, to: "home#category_filter"
  resources :topics do
    resources :posts, only: [:new, :edit, :create, :update]
  end

  # profile
  resources :profiles, only: [:update]
  namespace :avatars do
    post :reload
    get :edit
    post :update
  end

  # search
  get :search, to: 'search#index', as: :search

  # users
  resources :users, only: [:index, :show] do
    resources :message_threads, path: :messages
    collection do
      get :tab
    end
  end

  #resources :message_threads

  # admin
  namespace :admin do
    get '/', to: 'dashboard#index'
    get :dashboard, to: 'dashboard#index', as: :dashboard
    resources :categories

    authenticate :user, lambda { |u| u.is_admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

end
