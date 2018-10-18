# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Import::Work do
  let(:operation) { described_class.new }
  let(:change_set) { Work::SubmissionChangeSet.new(Work::Submission.new) }

  let(:import_work) do
    ImportFactory::Work.create(
      workID: [
        'workID_preservation.tif',
        'workID_preservation-redacted.tif',
        'workID_service.jp2',
        'workID_text.txt',
        'workID_thumb.jpg'
      ]
    )
  end

  describe '#call' do
    context 'when there is no import work' do
      subject { operation.call(change_set) }

      it { is_expected.to be_success }
    end

    context 'when the adapter fails' do
      let(:mock_adapter) { instance_double(IndexingAdapter) }

      before do
        allow(operation).to receive(:metadata_adapter).and_return(mock_adapter)
        allow(mock_adapter).to receive(:persister).and_raise(StandardError, 'unsupported adapter')
        change_set.import_work = import_work
      end

      it 'returns a failure' do
        expect {
          result = operation.call(change_set)
          expect(result).to be_failure
          expect(result.failure.message).to eq('Error importing the work: unsupported adapter')
        }.to change { Work::File.count }.by(0).and change { ::Work::FileSet.count }.by(0)
      end
    end

    context 'when text extraction fails' do
      let(:mock_extractor) { instance_double(Transaction::Operations::FileSet::ExtractText) }

      before do
        change_set.import_work = import_work
        allow(Transaction::Operations::FileSet::ExtractText).to receive(:new).and_return(mock_extractor)
        allow(mock_extractor).to receive(:call).and_return(Dry::Monads::Result::Failure.new('could not extract text'))
      end

      it 'adds the file sets to the work' do
        expect {
          result = operation.call(change_set)
          expect(result).to be_success
          expect(result.success).to eq(change_set)
          expect(result.success.file_set_ids.count).to eq(1)
        }.to change { ::Work::File.count }.by(5).and change { ::Work::FileSet.count }.by(1)
      end
    end

    context 'with an import work' do
      before { change_set.import_work = import_work }

      it 'adds the file sets to the work' do
        expect {
          result = operation.call(change_set)
          expect(result).to be_success
          expect(result.success).to eq(change_set)
          expect(result.success.file_set_ids.count).to eq(1)
        }.to change { ::Work::File.count }.by(5).and change { ::Work::FileSet.count }.by(1)
      end
    end
  end
end
