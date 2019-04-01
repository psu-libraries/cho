# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvController, type: :controller do
  let(:collection) { create :library_collection, title: 'my collection' }

  let(:csv_file) do
    CsvFactory::Generic.new(
      home_collection_id: [collection.id, collection.id, collection.id],
      work_type: ['Generic', 'Generic', 'Generic'],
      title: ['My Work 1', 'My Work 2', 'My Work 3']
    )
  end

  after { csv_file.unlink }

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
    let(:referrer) { 'http://test.host.com/csv/works/create' }

    before { request.headers['HTTP_REFERER'] = referrer }

    context 'when creating new works with a valid csv' do
      it 'validates the file' do
        expect(call).to render_template('dry_run_results')
        expect(response).to be_success
        expect(assigns(:presenter)).to be_a(Work::Import::CsvDryRunResultsPresenter)
        expect(assigns(:presenter).change_set_list.map(&:valid?)).to eq([true, true, true])
      end
    end

    context 'when creating new works with errors' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          home_collection_id: [nil, collection.id, 'bad'],
          work_type: ['Generic', 'Bad', 'Generic'],
          title: ['My Work 1', 'My Work 2', nil]
        )
      end

      it 'validates the file and reports the errors' do
        expect(call).to render_template('dry_run_results')
        expect(response).to be_success
        expect(assigns(:presenter)).to be_a(Work::Import::CsvDryRunResultsPresenter)
        expect(assigns(:presenter).change_set_list.map(&:valid?)).to eq([false, false])
        expect(assigns(:presenter).change_set_list.map(&:errors).map(&:messages)).to eq(
          [
            { work_type_id: ["can't be blank"] },
            { home_collection_id: ['bad does not exist'], title: ["can't be blank"] }
          ]
        )
        expect(File).to be_exist(assigns(:file_name))
      end
    end

    context 'when creating new works with a csv that has invalid columns' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          home_collection_id: [collection.id, collection.id],
          work_type: ['Generic', 'Generic'],
          title: ['My Work 1', 'My Work 2'],
          invalid_column: ['bad value 1', nil]
        )
      end

      it 'redirects to the create page' do
        expect(call).to redirect_to(csv_works_create_path)
        expect(flash[:error]).to eq("Unexpected column(s): 'invalid_column'")
      end
    end

    context 'when updating works with a csv with missing required columns' do
      let(:referrer) { 'http://test.host.com/csv/works/update' }

      it 'redirects to the update page' do
        expect(call).to redirect_to(csv_works_update_path)
        expect(flash[:error]).to eq('Missing id column for update')
      end
    end

    context 'when updating works with a file that is not a csv' do
      let(:referrer) { 'http://test.host.com/csv/works/update' }
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'sample_zip.zip')) }

      it 'redirects to the update page' do
        expect(call).to redirect_to(csv_works_update_path)
        expect(flash[:error]).to eq('invalid byte sequence in UTF-8')
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
        expect(assigns(:created).map(&:valid?)).to eq([true, true, true])
        expect(assigns(:created).map(&:title)).to eq([['My Work 1'], ['My Work 2'], ['My Work 3']])
      end
    end

    context 'when using update' do
      let(:update) { 'true' }

      let(:csv_file) do
        CsvFactory::Update.new(
          { title: 'My Updated Work 1' },
          { title: 'My Updated Work 2' },
          title: 'My Updated Work 3'
        )
      end

      it 'updates works from the csv file' do
        expect(call).to render_template('import_success')
        expect(response).to be_success
        expect(assigns(:created)).to be_a(Array)
        expect(assigns(:created).map(&:valid?)).to eq([true, true, true])
        expect(assigns(:created).map(&:title))
          .to eq([['My Updated Work 1'], ['My Updated Work 2'], ['My Updated Work 3']])
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
