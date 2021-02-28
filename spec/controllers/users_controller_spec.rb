require 'rails_helper'

describe UsersController, type: :controller do
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
