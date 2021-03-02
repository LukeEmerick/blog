Rails.application.routes.draw do
  post 'login', to: 'authentication#login'

  resources :posts do
    get 'search', on: :collection
  end

  resources :users do
    delete 'me', on: :collection
  end
end
