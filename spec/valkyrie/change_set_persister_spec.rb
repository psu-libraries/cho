# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe ChangeSetPersister do
  let(:metadata_adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }
  let(:storage_adapter)  { Valkyrie.config.storage_adapter }
  let(:change_set_persister) { described_class.new(metadata_adapter: metadata_adapter,
                                                   storage_adapter: storage_adapter) }

  it_behaves_like 'a Valkyrie::ChangeSetPersister'

  describe '#buffer_into_index' do
    let(:resource)   { build(:work, title: 'Buffer into index') }
    let(:change_set) { Work::SubmissionChangeSet.new(resource) }

    it 'persists a change set to Postgres' do
      expect {
        change_set_persister.buffer_into_index do |persist|
          persist.save(resource: change_set)
        end
      }.to change { metadata_adapter.query_service.find_all.count }.by(1)
    end

    it 'persists a change set to Solr' do
      expect {
        change_set_persister.buffer_into_index do |persist|
          persist.save(resource: change_set)
        end
      }.to change { metadata_adapter.index_adapter.query_service.find_all.count }.by(1)
    end
  end

  describe '#validate_and_save' do
    let(:change_set) { DataDictionary::FieldChangeSet.new(DataDictionary::Field.new) }

    it 'persists a change set to Postgres' do
      expect {
        change_set_persister.validate_and_save(change_set: change_set, resource_params: { label: 'abc123' })
      }.to change { metadata_adapter.query_service.find_all.count }.by(1)
    end

    context 'with files' do
      let(:resource)   { build(:work, title: 'with a file') }
      let(:change_set) { Work::SubmissionChangeSet.new(resource) }
      let(:temp_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt')) }
      let(:work_files) { Work::File.all }
      let(:work_file) { work_files.first }

      it 'saves the record and the file' do
        saved_change_set = nil
        expect {
          saved_change_set = change_set_persister.validate_and_save(change_set: change_set, resource_params: { label: 'abc123', file: temp_file })
        }.to change { metadata_adapter.query_service.find_all.count }.by(2)
        expect(saved_change_set.model.files).to eq(work_files.map(&:id))
        expect(work_file.original_filename).to eq('hello_world.txt')
        expect(work_file.use.map(&:to_s)).to eq(['http://pcdm.org/use#OriginalFile'])
      end
    end
  end

  describe '#validate_and_save_with_buffer' do
    let(:persister) { metadata_adapter.persister }
    let(:change_set) { DataDictionary::FieldChangeSet.new(DataDictionary::Field.new) }

    before do
      allow(metadata_adapter).to receive(:persister).and_return(persister)
    end

    it 'persists a change set to Postgres' do
      expect(persister).to receive(:buffer_into_index).and_call_original
      expect {
        saved_change_set = change_set_persister.validate_and_save_with_buffer(change_set: change_set, resource_params: { label: 'abc123' })
        expect(saved_change_set.label).to eq('abc123')
      }.to change { metadata_adapter.query_service.find_all.count }.by(1)
    end
  end

  context 'when the persister fails' do
    let(:mock_persister) { double }
    let(:change_set) { DataDictionary::FieldChangeSet.new(DataDictionary::Field.new) }

    before do
      allow(metadata_adapter).to receive(:persister).and_return(mock_persister)
    end

    describe '#save' do
      before do
        allow(mock_persister).to receive(:save).and_raise(StandardError, 'save was not successful')
      end

      it 'reports the error in the change set' do
        expect { change_set_persister.save(change_set: change_set) }.to raise_error(StandardError)
      end
    end

    describe '#validate_and_save' do
      before do
        allow(mock_persister).to receive(:save).and_raise(StandardError, 'save was not successful')
      end

      it 'reports the error in the save' do
        output = change_set_persister.validate_and_save(change_set: change_set, resource_params: { label: 'abc123' })
        expect(output.errors.messages).to eq(save: ['save was not successful'])
      end

      it 'reports the error in the parameters' do
        output = change_set_persister.validate_and_save(change_set: change_set, resource_params: {})
        expect(output.errors.messages).to eq(label: ['can\'t be blank'])
      end
    end

    describe '#validate_and_save_with_buffer' do
      before do
        allow(mock_persister).to receive(:buffer_into_index).and_raise(StandardError, 'save was not successful')
      end

      it 'reports the error in the save' do
        output = change_set_persister.validate_and_save_with_buffer(change_set: change_set, resource_params: { label: 'abc123' })
        expect(output.errors.messages).to eq(save: ['save was not successful'])
      end

      it 'reports the error in the parameters' do
        output = change_set_persister.validate_and_save_with_buffer(change_set: change_set, resource_params: {})
        expect(output.errors.messages).to eq(label: ['can\'t be blank'])
      end
    end

    describe '#delete' do
      before do
        allow(mock_persister).to receive(:delete).and_raise(StandardError, 'delete was not successful')
      end

      it 'reports the error in the change set' do
        output = change_set_persister.delete(change_set: change_set)
        expect(output.errors.messages).to eq(delete: ['delete was not successful'])
      end
    end
  end
end
