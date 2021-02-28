Rails.application.routes.draw do
  post 'login', to: 'authentication#login'

  resources :posts
  resources :users
end
