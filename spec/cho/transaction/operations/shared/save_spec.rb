# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Shared::Save do
  let(:collection) { create :collection }
  let(:change_set) { Work::SubmissionChangeSet.new(resource) }
  let(:operation) { described_class.new }

  describe '#call' do
    context 'when the resource is a work' do
      subject(:operation_result) { operation.call(change_set, persister: adapter.persister).success }

      let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

      let(:resource) { build :work_submission, member_of_collection_ids: [collection.id], title: 'My Title' }

      its(:class) { is_expected.to eq(Work::Submission) }
      its(:id) { is_expected.not_to be_empty }
      its(:title) { is_expected.to eq(['My Title']) }
    end

    context 'when save fails' do
      subject(:operation_result) { operation.call(change_set, persister: adapter.persister) }

      let(:adapter) { IndexingAdapter.new(metadata_adapter: nil, index_adapter: nil) }
      let(:persister) { IndexingAdapter::Persister.new(metadata_adapter: nil) }
      let(:resource) { build :work_submission, member_of_collection_ids: [collection.id], title: 'My Title' }

      before do
        allow(adapter).to receive(:persister).and_return(persister)
        allow(persister).to receive(:save).and_raise(StandardError.new('bogus error'))
      end

      it 'fails gracefully' do
        expect(operation_result).to be_failure
        expect(operation_result.failure.class).to eq(Work::SubmissionChangeSet)
        expect(operation_result.failure.errors.messages).to eq(save: ['bogus error'])
      end
    end
  end
end
