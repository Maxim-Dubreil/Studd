# config/routes.rb
Rails.application.routes.draw do
  root 'pages#landing_page'  # ← Root = Landing page
  
  # Pages avec shared components
  get 'dashboard', to: 'dashboards#index'
  get 'workspaces', to: 'workspaces#index'
  get 'about', to: 'pages#about'
  
  # Landing page sans shared components
  get 'landing_page', to: 'pages#landing_page'
end