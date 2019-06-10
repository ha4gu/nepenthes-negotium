Rails.application.routes.draw do
  root to: "static_pages#top"
  resources :tasks
  resources :users
end
