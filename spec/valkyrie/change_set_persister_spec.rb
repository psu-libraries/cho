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
          persist.save(resource: change_set.resource)
        end
      }.to change { metadata_adapter.query_service.find_all.count }.by(1)
    end

    it 'persists a change set to Solr' do
      expect {
        change_set_persister.buffer_into_index do |persist|
          persist.save(resource: change_set.resource)
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

    context 'with a saved resource' do
      let(:field) { create :data_dictionary_field, label: 'other', display_name: 'other name' }
      let(:change_set) { DataDictionary::FieldChangeSet.new(field) }
      let(:reloaded_dictionary_field) do
        Valkyrie.config.metadata_adapter.query_service.find_by(id: field.id)
      end

      it 'persists a change set to Postgres' do
        field # create the field prior to the expect
        expect {
          updated_change_set = change_set_persister.validate_and_save(
            change_set: change_set,
            resource_params: field.attributes.merge(display_name: 'my name')
          )
          expect(updated_change_set).to be_valid
          expect(updated_change_set.resource.display_name).to eq('my name')
        }.to change { metadata_adapter.query_service.find_all.count }.by(0)
      end
    end

    context 'with files' do
      let!(:collection) { create(:collection) }
      let(:resource) { build(:work, title: 'with a file', member_of_collection_ids: [collection.id]) }
      let(:change_set) { Work::SubmissionChangeSet.new(resource) }
      let(:temp_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt')) }
      let(:work_file_names) { Work::File.all.map(&:original_filename) }
      let(:work_file_uses) { Work::File.all.map { |file| file.use.map(&:to_s) }.flatten }

      it 'saves the record and the file set with its file and extracted text' do
        saved_change_set = nil
        expect {
          saved_change_set = change_set_persister.validate_and_save(
            change_set: change_set,
            resource_params: { label: 'abc123', file: temp_file }
          )
        }.to change { metadata_adapter.query_service.find_all.count }.by(4)
        expect(saved_change_set.model.member_ids).to eq(Work::FileSet.all.map(&:id))
        expect(work_file_names).to contain_exactly('hello_world.txt', 'hello_world.txt_text.txt')
        expect(work_file_uses).to contain_exactly(
          'http://pcdm.org/use#PreservationMasterFile',
          'http://pcdm.org/use#ExtractedText'
        )
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
        saved_change_set = change_set_persister.validate_and_save_with_buffer(
          change_set: change_set,
          resource_params: { label: 'abc123' }
        )
        expect(saved_change_set.label).to eq('abc123')
      }.to change { metadata_adapter.query_service.find_all.count }.by(1)
    end

    it 'reports the error in the parameters' do
      output = change_set_persister.validate_and_save_with_buffer(change_set: change_set, resource_params: {})
      expect(output.errors.messages).to eq(label: ['can\'t be blank'])
    end
  end

  describe '#delete' do
    context 'with a work containing files' do
      it "deletes all the resources from Postgres and Solr, the files from disk, and retains the work's collection" do
        work = create(:work, :with_file)
        change_set = Work::SubmissionChangeSet.new(work)
        expect(Work::Submission.all.count).to eq(1)
        expect(Work::FileSet.all.count).to eq(1)
        expect(Work::File.all.count).to eq(1)
        expect(metadata_adapter.index_adapter.query_service.find_all.count).to eq(4)
        expect(Metrics::Repository.storage_directory.join('hello_world.txt')).to be_exist
        change_set_persister.delete(change_set: change_set)
        expect(Work::Submission.all.count).to eq(0)
        expect(Work::FileSet.all.count).to eq(0)
        expect(Work::File.all.count).to eq(0)
        expect(metadata_adapter.index_adapter.query_service.find_all.count).to eq(1)
        expect(Metrics::Repository.storage_directory.join('hello_world.txt')).not_to be_exist
      end
    end

    context 'with a collection containing works' do
      let!(:work) { create(:work) }

      it 'deletes the collection and all of its works' do
        collection = Collection::Archival.find(work.member_of_collection_ids)
        change_set = Collection::ArchivalChangeSet.new(collection)
        expect(Work::Submission.all.count).to eq(1)
        expect(Collection::Archival.all.count).to eq(1)
        expect(metadata_adapter.index_adapter.query_service.find_all.count).to eq(2)
        change_set_persister.delete(change_set: change_set)
        expect(Work::Submission.all.count).to eq(0)
        expect(Collection::Archival.all.count).to eq(0)
        expect(metadata_adapter.index_adapter.query_service.find_all.count).to eq(0)
      end
    end

    context 'with a file set containing files' do
      let!(:change_set) { Work::FileSetChangeSet.new(create(:file_set, :with_member_file)) }

      it 'deletes the file set and its files' do
        expect(Work::Submission.all.count).to eq(1)
        expect(Work::FileSet.all.count).to eq(1)
        expect(Work::File.all.count).to eq(1)
        expect(metadata_adapter.index_adapter.query_service.find_all.count).to eq(3)
        change_set_persister.delete(change_set: change_set)
        expect(Work::Submission.all.count).to eq(1)
        expect(Work::Submission.all.first.member_ids).to be_empty
        expect(Work::FileSet.all.count).to eq(0)
        expect(Work::File.all.count).to eq(0)
        expect(metadata_adapter.index_adapter.query_service.find_all.count).to eq(1)
      end
    end
  end

  describe '#update_or_create' do
    subject(:update_or_create_call) { change_set_persister.update_or_create(resource, unique_attribute: :label) }

    let(:metadata_adapter) { Valkyrie.config.metadata_adapter }
    let(:resource) { build :data_dictionary_field, label: 'new_label' }

    it 'saves the resource and returns it' do
      expect { update_or_create_call }.to change(DataDictionary::Field, :count).by(1)
      expect(update_or_create_call.label).to eq('new_label')
    end

    context 'An existing field' do
      let(:existing_field) { create :data_dictionary_field, label: 'new_label' }

      before { existing_field }

      it 'does not save the field' do
        expect { update_or_create_call }.to change(DataDictionary::Field, :count).by(0)
        expect(update_or_create_call.id).to eq(existing_field.id)
      end
    end

    context 'when label is not the attribute' do
      subject(:update_or_create_call) {
        change_set_persister.update_or_create(existing_field, unique_attribute: :help_text)
      }

      let(:existing_field) { create :data_dictionary_field, help_text: 'Not used in another place' }

      before { existing_field }

      it 'does not save the field' do
        expect { update_or_create_call }.to change(DataDictionary::Field, :count).by(0)
        expect(update_or_create_call.id).to eq(existing_field.id)
      end
    end

    context 'with multiple attributes' do
      subject(:update_or_create_call) {
        change_set_persister.update_or_create(resource, unique_attributes: [:help_text, :label])
      }

      let(:resource) { build :data_dictionary_field,
                             help_text: 'Help text',
                             label: 'new_title',
                             display_name: 'my display' }
      let(:existing_field) { create :data_dictionary_field, help_text: 'Help text', label: 'new_title' }

      before { existing_field }

      it 'does not save the field' do
        expect { update_or_create_call }.to change(DataDictionary::Field, :count).by(0)
        expect(update_or_create_call.id).to eq(existing_field.id)
        expect(update_or_create_call.display_name).to eq('my display')
      end
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
        output = change_set_persister.validate_and_save_with_buffer(
          change_set: change_set,
          resource_params: { label: 'abc123' }
        )
        expect(output.errors.messages).to eq(save: ['save was not successful'])
      end
    end

    describe '#delete' do
      it 'reports the error in the change set' do
        output = change_set_persister.delete(change_set: change_set)
        expect(output.errors.messages).to eq(delete: ['resource is not saved'])
      end
    end
  end
end
