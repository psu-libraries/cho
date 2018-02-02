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
        output = change_set_persister.save(change_set: change_set)
        expect(output.errors.messages).to eq(save: ['save was not successful'])
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
