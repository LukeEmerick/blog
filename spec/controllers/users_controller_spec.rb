require 'rails_helper'

describe UsersController, type: :controller do
  describe '#get' do
    context 'when user is authenticated' do
      before(:context) do
        @user = create(:user, email: 'developer@developers.com', password: 'developer')
        command = AuthenticateUser.call(@user.email, @user.password)
        @token = command.result
      end

      # remove created user because it's not automatically rolled back
      after(:context) do
        user = User.find_by(email: 'developer@developers.com')
        user.delete
      end

      let(:user_data) do
        {
          id: @user.id,
          displayName: @user.displayName,
          email: @user.email,
          image: @user.image
        }
      end

      it 'renders user list with token' do
        request.headers.merge!(Authorization: @token)
        get :index, params: {}

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to eq([user_data])
      end

      it 'fails without token' do
        get :index, params: {}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token não encontrado')
      end

      it 'fails with and invalid token' do
        request.headers.merge!(Authorization: 'invalid_token')
        get :index, params: {}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token expirado ou inválido')
      end
    end
  end

  describe '#create' do
    context 'when good params are given' do
      let!(:user) { create :user }

      it 'renders a successful response for a new email' do
        post :create, params: {
          displayName: 'rubens silva',
          email: 'rubinho2@email.com',
          password: '123456'
        }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body).keys).to eq(['token'])
      end

      it 'fails if there alredy is a user with this email' do
        post :create, params: {
          displayName: 'rubens silva',
          email: user.email,
          password: '123456'
        }

        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body)).to eq('message' => 'Usuário já existe')
      end
    end

    context 'when bad params are given' do
      it 'fails with a short displayName' do
        post :create, params: {
          displayName: 'rubens',
          email: 'rubinho2@email.com',
          password: '123456'
        }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'message' => '"displayName" length must be at least 8 characters long' })
      end

      it 'fails without an email domain' do
        post :create, params: {
          displayName: 'rubens silva',
          email: 'rubinho2',
          password: '123456'
        }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'message' => '"email" must be a valid email' })
      end

      it 'fails without an email username' do
        post :create, params: {
          displayName: 'rubens silva',
          email: '@email.com',
          password: '123456'
        }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'message' => '"email" must be a valid email' })
      end

      it 'fails without an email' do
        post :create, params: {
          displayName: 'rubens silva',
          password: '123456'
        }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'message' => '"email" is required' })
      end

      it 'fails with a short password' do
        post :create, params: {
          displayName: 'rubens silva',
          email: 'rubinho2@email.com',
          password: '12345'
        }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'message' => '"password" length must be at least 6 characters long' })
      end

      it 'fails without an password' do
        post :create, params: {
          displayName: 'rubens silva',
          email: 'rubinho2@email.com'
        }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'message' => '"password" is required' })
      end
    end
  end
end
