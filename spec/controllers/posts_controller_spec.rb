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
        'published' => '2011-08-01T19:58:00.000Z',
        'updated' => '2011-08-01T19:58:51.947Z',
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

  describe '#update' do
    let!(:my_post) { create(:post, user: @user) }
    let!(:their_post) { create(:post) }

    context 'when good params are given' do
      let(:good_info) do
        {
          'title' => 'edited title text',
          'content' => 'edited content text'
        }
      end

      let(:good_params) do
        good_info.merge({ 'id' => my_post.id })
      end

      let(:expected_response) do
        good_info.merge({ 'userId' => @user.id })
      end

      let(:their_post_params) do
        good_info.merge({ 'id' => their_post.id })
      end

      it 'renders a successful response for a owned post' do
        request.headers.merge!(Authorization: @token)
        put :update, params: good_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(expected_response)
      end

      it 'fails on a post owned by someone else' do
        request.headers.merge!(Authorization: @token)
        put :update, params: their_post_params

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Usuário não autorizado')
      end
    end

    context 'when bad params are given' do
      let!(:my_post) { create(:post, user: @user) }

      it 'fails without a title' do
        request.headers.merge!(Authorization: @token)
        put :update, params: { id: my_post.id, content: 'content text' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq('message' => '"title" is required')
      end

      it 'fails without content' do
        request.headers.merge!(Authorization: @token)
        put :update, params: { id: my_post.id, title: 'title text' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq('message' => '"content" is required')
      end

      it 'fails without auth token' do
        put :update, params: { id: my_post.id, title: 'title text', content: 'content text' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token não encontrado')
      end

      it 'fails with an invalid token' do
        request.headers.merge!(Authorization: 'invalid_token')
        put :update, params: { id: my_post.id, title: 'title text', content: 'content text' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token expirado ou inválido')
      end
    end
  end

  describe '#delete' do
    let!(:my_post) { create(:post, user: @user) }
    let!(:their_post) { create(:post) }

    context 'when good params are given' do
      it 'destroys post, returns nothing' do
        request.headers.merge!(Authorization: @token)
        delete :destroy, params: { id: my_post.id }

        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_blank
      end

      it 'fails on a post owned by someone else' do
        request.headers.merge!(Authorization: @token)
        delete :destroy, params: { id: their_post.id }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Usuário não autorizado')
      end
    end

    context 'when bad params are given' do
      let!(:my_post) { create(:post, user: @user) }

      it 'fails without a valid post' do
        request.headers.merge!(Authorization: @token)
        delete :destroy, params: { id: -1 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq('message' => 'Post não existe')
      end

      it 'fails without auth token' do
        delete :destroy, params: { id: my_post.id }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token não encontrado')
      end

      it 'fails with an invalid token' do
        request.headers.merge!(Authorization: 'invalid_token')
        delete :destroy, params: { id: my_post.id }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token expirado ou inválido')
      end
    end
  end

  describe '#search' do
    let!(:title_post) { create(:post, title: 'TEST Title') }
    let!(:content_post) { create(:post, content: 'TesT conTenT.') }

    let(:title_post_data) do
      {
        'id' => title_post.id,
        'published' => title_post.created_at.as_json,
        'updated' => title_post.updated_at.as_json,
        'title' => 'TEST Title',
        'content' => title_post.content,
        'user' => {
          'id' => title_post.user_id,
          'displayName' => title_post.user.displayName,
          'email' => title_post.user.email,
          'image' => title_post.user.image
        }
      }
    end

    let(:content_post_data) do
      {
        'id' => content_post.id,
        'published' => content_post.created_at.as_json,
        'updated' => content_post.updated_at.as_json,
        'title' => content_post.title,
        'content' => 'TesT conTenT.',
        'user' => {
          'id' => content_post.user_id,
          'displayName' => content_post.user.displayName,
          'email' => content_post.user.email,
          'image' => content_post.user.image
        }
      }
    end

    context 'when good params are given' do
      it 'finds post by title' do
        request.headers.merge!(Authorization: @token)
        get :search, params: { q: 'test title' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([title_post_data])
      end

      it 'finds post by content' do
        request.headers.merge!(Authorization: @token)
        get :search, params: { q: 'test content.' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([content_post_data])
      end

      it 'finds all posts with a blank search' do
        request.headers.merge!(Authorization: @token)
        get :search, params: { q: '' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([title_post_data, content_post_data])
      end

      it "finds no posts with a search that doesn't match titles nor contents" do
        request.headers.merge!(Authorization: @token)
        get :search, params: { q: 'There is no title nor content like this' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when bad params are given' do
      it 'fails without auth token' do
        get :search, params: { q: '' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token não encontrado')
      end

      it 'fails with an invalid token' do
        request.headers.merge!(Authorization: 'invalid_token')
        get :search, params: { q: '' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('message' => 'Token expirado ou inválido')
      end
    end
  end
end
