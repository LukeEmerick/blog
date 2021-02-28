require 'rails_helper'

describe AuthenticationController, type: :controller do
  let!(:user) { create :user }

  context 'when the right params are given' do
    it 'renders a successful response' do
      post :login, params: { email: user.email, password: 'test1234' }

      expect(response).to be_successful
      expect(JSON.parse(response.body).keys).to eq(['token'])
    end
  end

  context 'when the wrong params are given' do
    it 'fails without an email' do
      post :login, params: { password: 'test1234' }

      expect(response).to be_bad_request
      expect(JSON.parse(response.body)).to eq({ 'message' => '"email" is required' })
    end

    it 'fails with a empty email' do
      post :login, params: { email: '', password: 'test1234' }

      expect(response).to be_bad_request
      expect(JSON.parse(response.body)).to eq({ 'message' => '"email" is not allowed to be empty' })
    end

    it 'fails without an password' do
      post :login, params: { email: user.email }

      expect(response).to be_bad_request
      expect(JSON.parse(response.body)).to eq({ 'message' => '"password" is required' })
    end

    it 'fails with a empty password' do
      post :login, params: { email: user.email, password: '' }

      expect(response).to be_bad_request
      expect(JSON.parse(response.body)).to eq({ 'message' => '"password" is not allowed to be empty' })
    end
  end
end
