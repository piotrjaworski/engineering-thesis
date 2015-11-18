require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, path: '',
    path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile/edit' },
    controllers: { registrations: :registrations, omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'home#index'

  # page
  get :topic_filter, to: "home#topic_filter"
  get :category_filter, to: "home#category_filter"
  resources :topics do
    resources :posts, only: [:new, :edit, :create, :update]
    post :close
    post :open
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
    resources :message_threads, path: :messages do
      post :reply, on: :collection
      get :autocomplete_user_username, on: :collection
    end
    collection do
      get :tab
    end
  end

  # notifications
  resources :notifications, only: [:index] do
    post :read
    collection do
      get :new_notifications
    end
  end

  # admin
  namespace :admin do
    get '/', to: 'dashboard#index'
    get :dashboard, to: 'dashboard#index', as: :dashboard
    resources :categories

    check_admin = lambda { |request| request.env["warden"].authenticate? and (request.env['warden'].user.admin?) }
    constraints check_admin do
      mount Sidekiq::Web => '/sidekiq'
    end
  end
end
