# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkObjectsController, type: :routing do
  describe 'routing' do
    it 'has no route to #index' do
      expect(get: '/work_objects').not_to route_to('work_objects#index')
    end

    it 'routes to #new' do
      expect(get: '/work_objects/new').to route_to('work_objects#new')
    end

    it 'routes to #show' do
      expect(get: '/work_objects/1').not_to route_to('work_objects#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/work_objects/1/edit').to route_to('work_objects#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/work_objects').to route_to('work_objects#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/work_objects/1').to route_to('work_objects#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/work_objects/1').to route_to('work_objects#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/work_objects/1').to route_to('work_objects#destroy', id: '1')
    end
  end
end
