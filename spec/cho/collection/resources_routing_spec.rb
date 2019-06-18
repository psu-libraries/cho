# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::ResourcesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/archival_collections/1/resources').to route_to(
        controller: 'collection/resources',
        action: 'index',
        archival_collection_id: '1'
      )
    end
  end
end
