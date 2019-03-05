# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::FileSetsController, type: :routing do
  describe 'routing' do
    it 'has no route to #index' do
      expect(get: '/file_sets').not_to route_to('work/file_sets#index')
    end

    it 'routes to #new' do
      expect(get: '/file_sets/new').not_to route_to('work/file_sets#new')
    end

    it 'routes to #show' do
      expect(get: '/file_sets/1').not_to route_to('work/file_sets#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/file_sets/1/edit').to route_to('work/file_sets#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/file_sets').not_to route_to('work/file_sets#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/file_sets/1').to route_to('work/file_sets#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/file_sets/1').to route_to('work/file_sets#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/file_sets/1').not_to route_to('work/file_sets#destroy', id: '1')
    end
  end
end
