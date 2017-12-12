# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::ArchivalCollectionsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/library_collections/new').to route_to('collection/library_collections#new')
    end

    it 'routes to #edit' do
      expect(get: '/library_collections/1/edit').to route_to('collection/library_collections#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/library_collections').to route_to('collection/library_collections#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/library_collections/1').to route_to('collection/library_collections#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/library_collections/1').to route_to('collection/library_collections#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/library_collections/1').to route_to('collection/library_collections#destroy', id: '1')
    end
  end
end
