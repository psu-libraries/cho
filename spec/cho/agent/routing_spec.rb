# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::ResourcesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/agents').to route_to('agent/resources#index')
    end

    it 'routes to #new' do
      expect(get: '/agents/new').to route_to('agent/resources#new')
    end

    it 'routes to #show' do
      expect(get: '/agents/1').to route_to('agent/resources#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/agents/1/edit').to route_to('agent/resources#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/agents').to route_to('agent/resources#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/agents/1').to route_to('agent/resources#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/agents/1').to route_to('agent/resources#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/agents/1').to route_to('agent/resources#destroy', id: '1')
    end
  end
end
