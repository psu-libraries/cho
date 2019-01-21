# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::Import::CsvController, type: :controller do
  let(:csv_file) do
    CsvFactory::Generic.new(
      given_name: ['John', 'Jane'],
      surname: ['Doe', 'Smith']
    )
  end

  describe 'GET #create' do
    subject(:call) { get :create }

    it 'returns a success response' do
      expect(call).to render_template('create')
      expect(response).to be_success
    end
  end

  describe 'GET #update' do
    subject(:call) { get :update }

    it 'returns a success response' do
      expect(call).to render_template('update')
      expect(response).to be_success
    end
  end

  describe 'POST #validate' do
    subject(:call) { post :validate, params: { 'csv_file': { file: file } } }

    let(:file) { Rack::Test::UploadedFile.new(csv_file.path) }
    let(:referrer) { 'http://test.host.com/csv/agents/create' }

    before { request.headers['HTTP_REFERER'] = referrer }

    context 'when creating new agents with a valid csv' do
      it 'validates the file' do
        expect(call).to render_template('dry_run_results')
        expect(response).to be_success
        expect(assigns(:presenter)).to be_a(Agent::Import::CsvDryRunResultsPresenter)
        expect(assigns(:presenter).change_set_list.map(&:valid?)).to eq([true, true])
      end
    end

    context 'when creating new works with errors' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          given_name: ['John', '', 'Thomas'],
          surname: ['', 'Smith', 'Anderson']
        )
      end

      before { create(:agent, given_name: 'Thomas', surname: 'Anderson') }

      it 'validates the file and reports the errors' do
        expect(call).to render_template('dry_run_results')
        expect(response).to be_success
        expect(assigns(:presenter)).to be_a(Agent::Import::CsvDryRunResultsPresenter)
        expect(assigns(:presenter).change_set_list.map(&:valid?)).to eq([false, false, false])
        expect(assigns(:presenter).change_set_list.map(&:errors).map(&:messages)).to eq(
          [
            { base: [], surname: ["can't be blank"] },
            { base: [], given_name: ["can't be blank"] },
            { base: ['Thomas Anderson already exists'] }
          ]
        )
        expect(File).to be_exist(assigns(:file_name))
      end
    end

    context 'when creating new works with a csv that has invalid columns' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          given_name: ['John', 'Jane'],
          surname: ['Doe', 'Smith'],
          invalid_column: ['bad1', 'bad2']
        )
      end

      it 'redirects to the create page' do
        expect(call).to redirect_to(csv_agents_create_path)
        expect(flash[:error]).to eq("Unexpected column(s): 'invalid_column'")
      end
    end

    context 'when updating works with a csv with missing required columns' do
      let(:referrer) { 'http://test.host.com/csv/agents/update' }

      it 'redirects to the update page' do
        expect(call).to redirect_to(csv_agents_update_path)
        expect(flash[:error]).to eq('Missing id column for update')
      end
    end
  end

  describe 'POST #import' do
    subject(:call) { post :import, params: { file_name: csv_file.path, update: update } }

    context 'when using create' do
      let(:update) { 'false' }

      it 'creates new works from the csv file' do
        expect(call).to render_template('import_success')
        expect(response).to be_success
        expect(assigns(:created)).to be_a(Array)
        expect(assigns(:created).map(&:valid?)).to eq([true, true])
        expect(assigns(:created).map(&:surname)).to contain_exactly('Doe', 'Smith')
      end
    end

    context 'when using update' do
      let(:update) { 'true' }

      let(:csv_file) do
        CsvFactory::AgentUpdate.new(
          { given_name: 'Huey', surname: 'Duck' },
          { given_name: 'Duey', surname: 'Duck' },
          given_name: 'Louis', surname: 'Duck'
        )
      end

      it 'updates works from the csv file' do
        expect(call).to render_template('import_success')
        expect(response).to be_success
        expect(assigns(:created)).to be_a(Array)
        expect(assigns(:created).map(&:valid?)).to eq([true, true, true])
        expect(assigns(:created).map(&:given_name))
          .to contain_exactly('Huey', 'Duey', 'Louis')
      end
    end

    context 'when the importer fails' do
      let(:update) { 'false' }
      let(:errors) { ['bad', 'no good', 'worse'] }
      let(:mock_importer) { instance_double(Csv::Importer, run: false, errors: errors) }

      before { allow(Csv::Importer).to receive(:new).and_return(mock_importer) }

      it 'renders the failure page' do
        expect(call).to render_template('import_failure')
        expect(response).to be_success
        expect(assigns(:errors)).to contain_exactly('bad', 'no good', 'worse')
      end
    end
  end
end
