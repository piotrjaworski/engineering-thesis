Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  root 'home#index'

  # admin
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :categories
  end

end
