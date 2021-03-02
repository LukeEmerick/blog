require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/user').to route_to('users#index')
    end

    it 'routes to #show' do
      expect(get: '/user/1').to route_to('users#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/user').to route_to('users#create')
    end

    it 'routes to #me' do
      expect(delete: '/user/me').to route_to('users#me')
    end
  end
end
