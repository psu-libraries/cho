# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MetadataFields', type: :request do
  describe 'GET /data_dictionary_fields' do
    it 'works! (now write some real specs)' do
      get data_dictionary_fields_path
      expect(response).to have_http_status(200)
    end
  end
end
