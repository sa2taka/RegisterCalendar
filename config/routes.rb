Rails.application.routes.draw do
  root 'events#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :events
  resources :members
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
