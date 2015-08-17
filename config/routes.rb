Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile/edit' }, controllers: { registrations: :registrations }
  root 'home#index'

  # page
  resources :topics do
    resources :posts, only: [:new, :edit, :create, :update]
  end

  # profile
  resources :profiles, only: [:update]

  # admin
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :categories do
      collection { post :sort }
    end
  end

end
