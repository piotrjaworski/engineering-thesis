Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  root 'home#index'

  # page
  resources :topics do
    resources :posts, only: [:new, :create]
  end

  # admin
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :categories do
      collection { post :sort }
    end
  end

end
