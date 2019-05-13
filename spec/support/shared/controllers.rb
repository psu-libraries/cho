# frozen_string_literal: true

RSpec.shared_examples 'a collection controller' do
  let(:valid_attributes) do
    {
      title: 'Sample collection',
      subtitle: 'use only for testing',
      description: 'A sample collection',
      workflow: 'default',
      access_level: 'public'
    }
  end

  let(:invalid_attributes) do
    { description: 'A sample collection' }
  end

  let(:valid_session) { {} }

  let(:param_key) { resource_class.model_name.param_key.to_sym }

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
      expect(assigns(:collection)).to be_a(described_class.new.send(:change_set_class))
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: collection.id }, session: valid_session
      expect(response).to be_success
      expect(assigns(:collection)).to be_a(described_class.new.send(:change_set_class))
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new collection' do
        expect {
          post :create, params: { param_key => valid_attributes }, session: valid_session
        }.to change(resource_class, :count).by(1)
      end

      it 'redirects to the created collection' do
        post :create, params: { param_key => valid_attributes }, session: valid_session
        expect(response).to redirect_to("/catalog/#{resource_class.last.id}")
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { param_key => invalid_attributes }, session: valid_session
        expect(response).to be_success
        expect(assigns[:collection].model.description).to eq(['A sample collection'])
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:updated_collection) { resource_class.find(collection.id) }

      let(:new_attributes) do
        {
          title: 'Updated collection',
          subtitle: 'use only for testing',
          description: 'An updated sample collection',
          workflow: 'default',
          access_level: 'public'
        }
      end

      it 'updates the requested collection' do
        put :update, params: { id: collection.to_param, param_key => new_attributes }, session: valid_session
        expect(updated_collection.title).to contain_exactly('Updated collection')
      end

      it 'redirects to the collection' do
        put :update, params: { id: collection.to_param, param_key => valid_attributes }, session: valid_session
        expect(response).to redirect_to("/catalog/#{collection.id}")
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { title: '', description: 'My Updated description' } }

      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: collection.to_param, param_key => invalid_attributes }, session: valid_session
        expect(response).to be_success
        expect(assigns[:collection].model.description).to eq(['My Updated description'])
      end
    end
  end
end
