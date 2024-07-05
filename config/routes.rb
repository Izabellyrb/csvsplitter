require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root to: 'import_data#import'

  # get 'index', to: 'import_data#index'
  # get 'search', to: 'import_data#search'

  namespace :api do
    namespace :v1 do
      post 'import', to: 'tasks#import'
    end
  end
end
