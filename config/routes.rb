Rails.application.routes.draw do
  root to: "static_pages#top"
  resources :labels, path: "tasks/labels", only: [:index, :show]
  resources :tasks do
    member do
      patch :toggle_status
      put   :toggle_status
    end
  end
  resources :users, path: "admin/users"
  get    "/login",         to: "sessions#new"
  delete "/expired-alert", to: "sessions#hide_alert"
  resources :sessions, only: [:create, :destroy]
end
