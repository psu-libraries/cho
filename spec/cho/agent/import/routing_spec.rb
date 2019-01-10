# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::Import::CsvController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(get: '/csv/agents/create').to route_to('agent/import/csv#create')
    end

    it 'routes to #update' do
      expect(get: '/csv/agents/update').to route_to('agent/import/csv#update')
    end

    it 'routes to #validate' do
      expect(post: '/csv/agents/validate').to route_to('agent/import/csv#validate')
    end

    it 'routes to #import' do
      expect(post: '/csv/agents/import').to route_to('agent/import/csv#import')
    end
  end
end
