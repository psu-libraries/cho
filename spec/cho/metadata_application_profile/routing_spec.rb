# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataApplicationProfile::FieldsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/metadata_application_profile_fields').to route_to('metadata_application_profile/fields#index')
    end

    it 'routes to #new' do
      expect(get: '/metadata_application_profile_fields/new').to route_to('metadata_application_profile/fields#new')
    end

    it 'routes to #show' do
      expect(get: '/metadata_application_profile_fields/1').to route_to('metadata_application_profile/fields#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/metadata_application_profile_fields/1/edit').to route_to('metadata_application_profile/fields#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/metadata_application_profile_fields').to route_to('metadata_application_profile/fields#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/metadata_application_profile_fields/1').to route_to('metadata_application_profile/fields#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/metadata_application_profile_fields/1').to route_to('metadata_application_profile/fields#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/metadata_application_profile_fields/1').to route_to('metadata_application_profile/fields#destroy', id: '1')
    end
  end
end
