# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch::DeleteController, type: :routing do
  describe 'routing' do
    it 'routes to #confirm' do
      expect(post: '/batch/delete').to route_to('batch/delete#confirm')
    end

    it 'routes to #destroy' do
      expect(delete: '/batch/delete').to route_to('batch/delete#destroy')
    end

    it 'routes to #index' do
      expect(get: '/batch/delete').to route_to('batch/delete#index')
    end
  end
end
