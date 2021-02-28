require 'rails_helper'

describe PostsController, type: :controller do
  before do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  before(:all) do
    @user = create(:user, email: 'developer@developers.com', password: 'developer')
    command = AuthenticateUser.call(@user.email, @user.password)
    @token = command.result
  end

  after(:all) do
    user = User.find_by(email: 'developer@developers.com')
    user.delete
  end

  describe '#create' do
    context 'when good params are given' do
      it 'renders a successful response for a new email' do
        request.headers.merge!(Authorization: @token)
        post :create, params: { title: 'title text', content: 'content text' }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(good_params.merge('userID', @user.id))
      end
    end

    describe '#create' do
      context 'when bad params are given' do
        it 'fails without a titlle' do
          request.headers.merge!(Authorization: @token)
          post :create, params: { content: 'content text' }

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq('message' => '"title" is required')
        end

        it 'fails without content' do
          request.headers.merge!(Authorization: @token)
          post :create, params: { title: 'title text' }

          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to eq('message' => '"content" is required')
        end

        it 'fails without auth token' do
          post :create, params: { title: 'title text', content: 'content text' }

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq('message' => 'Token não encontrado')
        end

        it 'fails with an invalid token' do
          request.headers.merge!(Authorization: 'invalid_token')
          post :create, params: { title: 'title text', content: 'content text' }

          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)).to eq('message' => 'Token expirado ou inválido')
        end
      end
    end
  end
end
