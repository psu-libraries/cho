# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MetadataFields', type: :request do
  describe 'GET /metadata_application_profile_fields' do
    it 'works! (now write some real specs)' do
      get metadata_application_profile_fields_path
      expect(response).to have_http_status(200)
    end
  end
end
