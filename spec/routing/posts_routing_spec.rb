require 'rails_helper'

RSpec.describe PostsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/post').to route_to('posts#index')
    end

    it 'routes to #show' do
      expect(get: '/post/1').to route_to('posts#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/post').to route_to('posts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/post/1').to route_to('posts#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/post/1').to route_to('posts#update', id: '1')
    end

    it 'routes to #search' do
      expect(get: '/post/search').to route_to('posts#search')
    end
  end
end
