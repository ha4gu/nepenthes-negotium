Rails.application.routes.draw do
  root to: "static_pages#top"
  resources :tasks
  resources :users
  get "/login", to: "sessions#new"
  resources :sessions, only: [:create, :destroy]
end
