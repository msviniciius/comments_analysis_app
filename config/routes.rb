require 'sidekiq/web'
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index]
      get 'progress/:user_id', to: 'progress#show'
    end
  end
  
  resources :keywords, only: [:index, :create, :edit, :update, :destroy]
  resources :comments, only: [:index]
  
  mount Sidekiq::Web => '/sidekiq'
end