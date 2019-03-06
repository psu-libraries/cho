# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::FileSetsController, type: :controller do
  let(:metadata_adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }
  let(:resource) { create :file_set }
  let(:index_solr) { Valkyrie::MetadataAdapter.find(:index_solr) }

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: resource.id }
      expect(response).to be_success
      expect(assigns(:file_set)).to be_a(Work::FileSetChangeSet)
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { title: 'Updated Title' } }

    context 'with valid params' do
      let(:updated_resource) { Work::FileSet.find(resource.id) }

      it 'updates the requested work' do
        put :update, params: { id: resource.to_param, 'work_file_set': new_attributes }
        expect(updated_resource.title).to contain_exactly('Updated Title')
      end

      it 'redirects to the work' do
        put :update, params: { id: resource.to_param, 'work_file_set': new_attributes }
        expect(response).to redirect_to("/catalog/#{resource.id}")
      end
    end

    context 'with an invalid change set' do
      let(:invalid_attributes) { { title: '', description: 'my new description' } }

      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: resource.to_param, 'work_file_set': invalid_attributes }
        expect(response).to be_success
        expect(assigns(:file_set).model.description).to eq(['my new description'])
      end
    end
  end
end
