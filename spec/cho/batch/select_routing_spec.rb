# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch::SelectController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/select').to route_to('batch/select#index')
    end
  end
end
