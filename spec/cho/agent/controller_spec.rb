# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::ResourcesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # MetadataField. As you add validations to MetadataField, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      'surname' => 'Brown',
      'given_name' => 'Sally'
    }
  end

  let(:invalid_attributes) do
    {
      'surname' => 'Brown',
      'given_name' => ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MetadataFieldsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context 'valid object created' do
    let!(:agent) { create(:agent) }
    let(:reloaded_agent) do
      Valkyrie.config.metadata_adapter.query_service.find_by(id: agent.id)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index, params: {}, session: valid_session
        expect(response).to be_success
      end
    end

    describe 'GET #index.json' do
      render_views

      let(:json_response) { JSON.parse(response.body) }

      it 'returns json' do
        get :index, params: {}, session: valid_session, format: :json
        expect(response.content_type).to eq('application/json')
        expect(json_response.first).to include('given_name' => 'John')
      end
    end

    describe 'GET #index.csv' do
      render_views
      it 'returns csv' do
        get :index, params: {}, session: valid_session, format: :csv
        expect(response.content_type).to eq('text/csv')
        expect(response.body).to include(
          "Id,Surname,Given Name\n"
        )
        expect(response.body).to include(
          "#{agent.id},#{agent.surname},#{agent.given_name}\n"
        )
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: agent.to_param }, session: valid_session
        expect(response).to be_success
        expect(assigns(:agent)).to be_a(Agent::Resource)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: agent.to_param }, session: valid_session
        expect(response).to be_success
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) do
          {
            'surname' => 'Smith',
            'given_name' => 'John'
          }
        end

        it 'updates the requested agent' do
          put :update, params: { id: agent.to_param, agent: new_attributes },
                       session: valid_session
          expect(response).to redirect_to(reloaded_agent)
          expect(reloaded_agent.surname).to eq('Smith')
          expect(reloaded_agent.given_name).to eq('John')
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: agent.to_param, agent: invalid_attributes },
                       session: valid_session
          expect(response).to be_success
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested agent' do
        expect {
          delete :destroy, params: { id: agent.to_param }, session: valid_session
        }.to change(Agent::Resource, :count).by(-1)
      end

      it 'redirects to the agent list' do
        delete :destroy, params: { id: agent.to_param }, session: valid_session
        expect(response).to redirect_to(agent_resources_url)
      end
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
      expect(assigns(:agent)).to be_a(Agent::ChangeSet)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new MetadataField' do
        expect {
          post :create, params: { agent: valid_attributes }, session: valid_session
        }.to change(Agent::Resource, :count).by(1)
      end

      it 'redirects to the created agent' do
        post :create, params: { agent: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Agent::Resource.all.sort_by(&:created_at).last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { agent: invalid_attributes }, session: valid_session
        expect(response).to be_success
        expect(assigns[:agent].errors.first)
          .to eq([:given_name, 'can\'t be blank'])
      end
    end

    context 'error on save' do
      let(:metadata_adapter) { Valkyrie::MetadataAdapter.find(:postgres) }
      let(:storage_adapter)  { Valkyrie.config.storage_adapter }
      let(:persister) { ChangeSetPersister.new(metadata_adapter: metadata_adapter, storage_adapter: storage_adapter) }
      let(:metadata_persister) { instance_double(Valkyrie::Persistence::Postgres::Persister) }

      before do
        allow(ChangeSetPersister).to receive(:new).and_return(persister)
        allow(metadata_adapter).to receive(:persister).and_return(metadata_persister)
        allow(metadata_persister).to receive(:save).and_raise(StandardError.new('an error saving'))
      end

      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { agent: valid_attributes }, session: valid_session
        expect(response).to be_success
        expect(assigns[:agent].errors.first).to eq([:save, 'an error saving'])
      end
    end
  end
end
