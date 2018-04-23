Rails.application.routes.draw do
  resources :users
  resources :sessions
  resources :application
  root 'application#index'
end
