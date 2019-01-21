# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(get: '/csv/works/create').to route_to('work/import/csv#create')
    end

    it 'routes to #update' do
      expect(get: '/csv/works/update').to route_to('work/import/csv#update')
    end

    it 'routes to #validate' do
      expect(post: '/csv/works/validate').to route_to('work/import/csv#validate')
    end

    it 'routes to #import' do
      expect(post: '/csv/works/import').to route_to('work/import/csv#import')
    end
  end
end
