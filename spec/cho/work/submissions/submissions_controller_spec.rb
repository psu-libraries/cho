# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::SubmissionsController, type: :controller do
  let(:metadata_adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }
  let(:resource) { create :work }
  let(:index_solr)    { Valkyrie::MetadataAdapter.find(:index_solr) }

  describe 'GET #new' do
    context 'with a work type' do
      it 'returns a success response' do
        get :new, params: { work_type_id: 'type' }
        expect(response).to be_success
        expect(assigns(:work)).to be_a(Work::SubmissionChangeSet)
      end
    end

    context 'without a work type' do
      it 'redirects to the home page' do
        get :new
        expect(response).to redirect_to('/')
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: resource.id }
      expect(response).to be_success
      expect(assigns(:work)).to be_a(Work::SubmissionChangeSet)
    end
  end

  describe 'POST #create' do
    let(:work_type_id) { Work::Type.find_using(label: 'Generic').first }
    let(:valid_attributes) { { title: 'New Title', work_type_id: work_type_id } }
    let(:resource) { Work::Submission.all.last }

    context 'with valid params' do
      it 'creates a new Work' do
        expect(index_solr.query_service.find_all.to_a.length).to eq 0
        expect {
          post :create, params: { 'work_submission': valid_attributes }
        }.to change { Work::Submission.count }.by(1)
        expect(index_solr.query_service.find_all.to_a.length).to eq 1
      end

      it 'redirects to the created work' do
        post :create, params: { 'work_submission': valid_attributes }
        expect(response).to redirect_to("/catalog/#{resource.id}")
      end
    end

    context 'with an invalid change set' do
      let(:invalid_attributes) { { title: 'Missing a work type' } }

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { 'work_submission': invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { title: 'Updated Title' } }

    context 'with valid params' do
      let(:updated_resource) { Work::Submission.find(resource.id) }

      it 'updates the requested work' do
        put :update, params: { id: resource.to_param, 'work_submission': new_attributes }
        expect(updated_resource.title).to contain_exactly('Updated Title')
      end

      it 'redirects to the work' do
        put :update, params: { id: resource.to_param, 'work_submission': new_attributes }
        expect(response).to redirect_to("/catalog/#{resource.id}")
      end
    end

    context 'with an invalid change set' do
      let(:invalid_attributes) { { title: '' } }

      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: resource.to_param, 'work_submission': invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    before { resource }
    it 'destroys the requested work' do
      expect {
        delete :destroy, params: { id: resource.to_param }
      }.to change { metadata_adapter.query_service.find_all.to_a.count }.by(-1)
    end

    it 'redirects to the works list' do
      delete :destroy, params: { id: resource.to_param }
      expect(response).to redirect_to('/')
    end
  end
end
