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

  describe '#show' do
    let!(:post) { create(:post, created_at: '2011-08-01T19:58:00.000Z', updated_at: '2011-08-01T19:58:51.947Z') }

    let(:post_response) do
      {
        'id' => post.id,
        'published' => '2011-08-01T19:58:00Z',
        'updated' => '2011-08-01T19:58:51Z',
        'title' => post.title,
        'content' => post.content,
        'user' => {
          'id' => post.user_id,
          'displayName' => post.user.displayName,
          'email' => post.user.email,
          'image' => post.user.image
        }
      }
    end

    context 'when good params are given' do
      it 'renders a successful with a valid id' do
        request.headers.merge!(Authorization: @token)
        get :show, params: { id: post.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(post_response)
      end
    end

    context 'when bad params are given' do
      it 'fails with and invalid id' do
        request.headers.merge!(Authorization: @token)
        get :show, params: { id: -1 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq('message' => 'Post não existe')
      end

      it 'fails without auth token' do
        get :show, params: { id: post.id }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token não encontrado')
      end

      it 'fails with an invalid token' do
        request.headers.merge!(Authorization: 'invalid_token')
        get :show, params: { id: post.id }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token expirado ou inválido')
      end
    end
  end

  describe '#create' do
    context 'when good params are given' do
      let(:good_params) do
        {
          'title' => 'title text',
          'content' => 'content text'
        }
      end

      it 'renders a successful response' do
        request.headers.merge!(Authorization: @token)
        post :create, params: good_params

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to eq(good_params.merge({ 'userId' => @user.id }))
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
