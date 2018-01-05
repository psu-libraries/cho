# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  let(:collection) { create_for_repository(:collection) }

  let(:valid_attributes) do
    { title: 'Sample collection', description: 'A sample collection', collection_type: 'archival' }
  end

  let(:invalid_attributes) do
    { title: 'Sample collection', description: 'A sample collection' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CollectionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: collection.id }, session: valid_session
      expect(response).to be_success
      expect(assigns(:collection)).to be_a(CollectionChangeSet)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Collection' do
        expect {
          post :create, params: { collection: valid_attributes }, session: valid_session
        }.to change(Collection, :count).by(1)
      end

      it 'redirects to the created collection' do
        post :create, params: { collection: valid_attributes }, session: valid_session
        expect(response).to redirect_to("/catalog/#{Collection.last.id}")
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { collection: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:updated_collection) { Collection.find(collection.id) }

      let(:new_attributes) do
        { title: 'Updated collection', description: 'An updated sample collection' }
      end

      it 'updates the requested collection' do
        put :update, params: { id: collection.to_param, collection: new_attributes }, session: valid_session
        expect(updated_collection.title).to eq('Updated collection')
      end

      it 'redirects to the collection' do
        put :update, params: { id: collection.to_param, collection: valid_attributes }, session: valid_session
        expect(response).to redirect_to("/catalog/#{collection.id}")
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { title: '' } }

      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: collection.to_param, collection: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    before { collection }
    it 'destroys the requested collection' do
      expect {
        delete :destroy, params: { id: collection.to_param }, session: valid_session
      }.to change(Collection, :count).by(-1)
    end

    it 'redirects to the collections list' do
      delete :destroy, params: { id: collection.to_param }, session: valid_session
      expect(response).to redirect_to('/')
    end
  end
end
