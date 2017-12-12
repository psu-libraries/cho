# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::ArchivalCollectionsController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/archival_collections/new').to route_to('collection/archival_collections#new')
    end

    it 'routes to #edit' do
      expect(get: '/archival_collections/1/edit').to route_to('collection/archival_collections#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/archival_collections').to route_to('collection/archival_collections#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/archival_collections/1').to route_to('collection/archival_collections#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/archival_collections/1').to route_to('collection/archival_collections#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/archival_collections/1').to route_to('collection/archival_collections#destroy', id: '1')
    end
  end
end
