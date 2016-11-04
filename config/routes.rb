Rails.application.routes.draw do
  root 'pages#index'
  # resources :countries, only: [:index, :show]
  resources :strikes, only: [:index, :show]
  resources :spreadsheets, only: :create
  resources :summaries, only: :index
end
