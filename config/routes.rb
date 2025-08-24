# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  devise_scope :user do
    get 'login', to: 'users/sessions#new', as: :login
    get 'signup', to: 'users/registrations#new', as: :signup
    delete 'logout', to: 'devise/sessions#destroy', as: :logout
  end
  get "home/index"

  resources :workspaces, only: %i[index show] do
    # Si ton contrôleur est Workspaces::FlashcardsController :
    scope module: :workspaces do
      resources :flashcards, only: %i[index show create destroy]
      resource :mindmaps, only: %i[show create destroy update]
      resource :quiz, only: %i[show create destroy] # Changé de resources à resource
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Routes principales de l'application
  root "pages#landing_page"
  get '/dashboard', to: 'dashboards#index', as: :dashboard

  resources :workspaces, only: [:index, :show, :create, :update, :destroy]
  resources :raw_contents, only: [:create, :update]
  resources :icons, only: [:index]
  get '/blog', to: 'pages#blog', as: :blog
  get '/courses', to: 'pages#courses', as: :courses
  get '/calendar', to: 'pages#calendar', as: :calendar

  # Pages statiques temporaires
  get '/about',  to: 'pages#about',  as: :about
  get '/docs', to: 'pages#docs', as: :docs
  get '/landing', to: 'pages#landing_page', as: :landing
  get '/profil', to: 'pages#profil_page', as: :profil
  namespace :api do
    namespace :v1 do
      get '/me', to: 'users#me'
      get '/courses/next', to: 'courses#next'
      get '/progress', to: 'progress#index'
      get '/notifications', to: 'notifications#index'
      get '/posts/latest', to: 'posts#latest'
    end
  end
end