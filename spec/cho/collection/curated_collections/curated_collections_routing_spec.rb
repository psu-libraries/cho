# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::ArchivalCollectionsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/curated_collections/new').to route_to('collection/curated_collections#new')
    end

    it 'routes to #edit' do
      expect(get: '/curated_collections/1/edit').to route_to('collection/curated_collections#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/curated_collections').to route_to('collection/curated_collections#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/curated_collections/1').to route_to('collection/curated_collections#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/curated_collections/1').to route_to('collection/curated_collections#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/curated_collections/1').to route_to('collection/curated_collections#destroy', id: '1')
    end
  end
end
