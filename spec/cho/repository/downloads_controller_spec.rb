# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::DownloadsController, type: :controller do
  describe 'GET #download', :with_psu_user do
    context 'when not requesting a specific use type with a preservation file present' do
      let(:file_set) { create(:file_set, :with_preservation_file) }

      specify do
        get :download, params: { id: file_set.id }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (preservation)')
      end
    end

    context 'when not requesting a specific use type with a redacted preservation file present' do
      let(:file_set) { create(:file_set, :with_redacted_preservation_file) }

      specify do
        get :download, params: { id: file_set.id }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (redacted preservation)')
      end
    end

    context 'when not requesting a specific use type with a service file present' do
      let(:file_set) { create(:file_set, :with_service_file) }

      specify do
        get :download, params: { id: file_set.id }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (service)')
      end
    end

    context 'when not requesting a specific use type with an access file present' do
      let(:file_set) { create(:file_set, :with_access_file) }

      specify do
        get :download, params: { id: file_set.id }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (access)')
      end
    end

    context 'when requesting the preservation file when a redacted one is present' do
      let(:file_set) { create(:file_set, :with_redacted_preservation_file) }

      specify do
        get :download, params: { id: file_set.id, use_type: 'PreservationMasterFile' }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (redacted preservation)')
      end
    end

    context 'when requesting the preservation file' do
      let(:file_set) { create(:file_set, :with_preservation_file) }

      specify do
        get :download, params: { id: file_set.id, use_type: 'PreservationMasterFile' }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (preservation)')
      end
    end

    context 'when requesting the access file' do
      let(:file_set) { create(:file_set, :with_access_file) }

      specify do
        get :download, params: { id: file_set.id, use_type: 'AccessFile' }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (access)')
      end
    end

    context 'when requesting the service file' do
      let(:file_set) { create(:file_set, :with_service_file) }

      specify do
        get :download, params: { id: file_set.id, use_type: 'ServiceFile' }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (service)')
      end
    end

    context 'when requesting the extracted text file' do
      let(:file_set) { create(:file_set, :with_extracted_text_file) }

      specify do
        get :download, params: { id: file_set.id, use_type: 'ExtractedText' }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (extracted text)')
      end
    end

    context 'when requesting the thumbnail file' do
      let(:file_set) { create(:file_set, :with_thumbnail_file) }

      specify do
        get :download, params: { id: file_set.id, use_type: 'ThumbnailImage' }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (thumbnail)')
      end
    end

    context 'with an unsupported use type' do
      let(:file_set) { create(:file_set, :with_service_file) }

      specify do
        get :download, params: { id: file_set.id, use_type: :bogus }
        expect(response).to be_success
        expect(response.body).to eq('Hello World! (service)')
      end
    end

    context 'with no files in the file set' do
      let(:file_set) { create(:file_set) }

      specify do
        get :download, params: { id: file_set.id }
        expect(response).to be_not_found
      end
    end

    context 'when the file set does not exist' do
      specify do
        get :download, params: { id: 'missing-id' }
        expect(response).to be_not_found
      end
    end

    context 'when the file does not exist' do
      let(:file_set) { create(:file_set, :with_missing_file) }

      specify do
        get :download, params: { id: file_set.id }
        expect(response).to be_not_found
      end
    end
  end
end
