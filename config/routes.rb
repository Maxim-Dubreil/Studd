# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  get "home/index"

  namespace :tools do
  get 'flashcards/new', to: 'flashcards#new', as: :new_flashcard  # GET - Affiche le formulaire
  post 'flashcards', to: 'flashcards#create', as: :flashcards     # POST - Traitement
end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"


  # Pages statiques temporaires
  get '/dashboard', to: 'dashboards#index'
  resources :workspaces
  root "pages#landing_page"
end