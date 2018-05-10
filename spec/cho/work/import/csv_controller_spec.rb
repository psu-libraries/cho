# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvController, type: :controller do
  let(:collection) { create :library_collection, title: 'my collection' }
  let(:work_1_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world.txt') }
  let(:work_2_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world2.txt') }
  let(:work_3_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world3.txt') }
  let(:csv_file) do
    csv_file = Tempfile.new('csv_file.csv')

    csv_file.write("member_of_collection_ids,work_type,title,file_name\n")
    csv_file.write("#{collection.id},Generic,My Work 1,#{work_1_file_name}\n")
    csv_file.write("#{collection.id},Generic,My Work 2,#{work_2_file_name}\n")
    csv_file.write("#{collection.id},Generic,My Work 3,#{work_3_file_name}\n")
    csv_file.close

    csv_file
  end

  describe 'GET #new' do
    subject(:new_call) { get :new }

    it 'returns a success response' do
      expect(new_call).to render_template('new')
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    subject(:create_call) { post :create, params: { 'work_import_csv_file': { file: file } } }

    let(:file) { Rack::Test::UploadedFile.new(csv_file.path) }

    it 'runs a dry run on the file' do
      expect(create_call).to render_template('dry_run_results')
      expect(response).to be_success
      expect(assigns(:presenter)).to be_a(Work::Import::CsvDryRunResultsPresenter)
      expect(assigns(:presenter).change_set_list.map(&:valid?)).to eq([true, true, true])
      expect(File).to be_exist(assigns(:file_name))
    end

    context 'invalid csv' do
      let(:csv_file) do
        csv_file = Tempfile.new('csv_file.csv')

        csv_file.write("member_of_collection_ids,work_type,title,file_name\n")
        csv_file.write(",Generic,My Work 1,#{work_1_file_name}\n")
        csv_file.write("#{collection.id},Bad,My Work 2,#{work_2_file_name}\n")
        csv_file.write("bad,Generic,,#{work_3_file_name}\n")
        csv_file.close

        csv_file
      end

      it 'runs a dry run on the file' do
        expect(create_call).to render_template('dry_run_results')
        expect(response).to be_success
        expect(assigns(:presenter)).to be_a(Work::Import::CsvDryRunResultsPresenter)
        expect(assigns(:presenter).change_set_list.map(&:valid?)).to eq([false, false, false])
        expect(assigns(:presenter).change_set_list.map(&:errors).map(&:messages)).to eq([{ member_of_collection_ids: [' does not exist'] }, { work_type_id: ["can't be blank"] }, { member_of_collection_ids: ['bad does not exist'], title: ["can't be blank"] }])
        expect(File).to be_exist(assigns(:file_name))
      end
    end
  end

  describe 'POST #run_import' do
    subject(:import_call) { post :run_import, params: { file_name: csv_file.path } }

    it 'runs an import on the file' do
      expect(import_call).to render_template('import_success')
      expect(response).to be_success
      expect(assigns(:created)).to be_a(Array)
      expect(assigns(:created).map(&:valid?)).to eq([true, true, true])
      expect(assigns(:created).map(&:title)).to eq([['My Work 1'], ['My Work 2'], ['My Work 3']])
    end
  end
end
