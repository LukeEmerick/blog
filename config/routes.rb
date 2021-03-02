Rails.application.routes.draw do
  post 'login', to: 'authentication#login'

  resources :user, controller: 'users', only: %i[index show create] do
    delete 'me', on: :collection
  end

  resources :post, controller: 'posts' do
    get 'search', on: :collection
  end
end
