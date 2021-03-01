Rails.application.routes.draw do
  post 'login', to: 'authentication#login'

  resources :posts
  resources :users do
    delete 'me', on: :collection
  end
end
