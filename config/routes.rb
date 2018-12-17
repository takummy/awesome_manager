Rails.application.routes.draw do

  root 'home#top'
  
  resources :tasks

  resources :users, only: %i(new create show)
  namespace :admin do
    resources :users
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
