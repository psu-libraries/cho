# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::SubmissionsController, type: :routing do
  describe 'routing' do
    it 'has no route to #index' do
      expect(get: '/works').not_to route_to('work/submissions#index')
    end

    it 'routes to #new' do
      expect(get: '/works/new').to route_to('work/submissions#new')
    end

    it 'routes to #show' do
      expect(get: '/works/1').not_to route_to('work/submissions#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/works/1/edit').to route_to('work/submissions#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/works').to route_to('work/submissions#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/works/1').to route_to('work/submissions#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/works/1').to route_to('work/submissions#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/works/1').to route_to('work/submissions#destroy', id: '1')
    end
  end
end
