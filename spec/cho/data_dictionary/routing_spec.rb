# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::FieldsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/data_dictionary_fields').to route_to('data_dictionary/fields#index')
    end

    it 'routes to #new' do
      expect(get: '/data_dictionary_fields/new').to route_to('data_dictionary/fields#new')
    end

    it 'routes to #show' do
      expect(get: '/data_dictionary_fields/1').to route_to('data_dictionary/fields#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/data_dictionary_fields/1/edit').to route_to('data_dictionary/fields#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/data_dictionary_fields').to route_to('data_dictionary/fields#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/data_dictionary_fields/1').to route_to('data_dictionary/fields#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/data_dictionary_fields/1').to route_to('data_dictionary/fields#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/data_dictionary_fields/1').to route_to('data_dictionary/fields#destroy', id: '1')
    end
  end
end
