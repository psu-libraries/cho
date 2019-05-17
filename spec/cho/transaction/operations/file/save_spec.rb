# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::Save do
  let(:operation) { described_class.new }

  describe '#call' do
    context 'with a successful save' do
      let!(:collection) { create(:collection) }
      let(:resource) { build(:work, title: 'with a file', home_collection_id: [collection.id]) }
      let(:change_set) { Work::SubmissionChangeSet.new(resource) }
      let(:temp_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt')) }
      let(:resource_params) { { label: 'abc123', file: temp_file } }

      before { change_set.validate(resource_params) }

      it 'returns Success' do
        expect {
          result = operation.call(change_set)
          expect(result).to be_success
          expect(result.success).to eq(change_set)
          expect(result.success.member_ids.count).to eq(1)
        }.to change { Work::File.count }.by(2).and change { Work::FileSet.count }.by(1)
      end

      it 'persists the fits characterization to the preservation file' do
        operation.call(change_set)

        files = Work::File.all
        expect(files.count).to eq(2) # Sanity
        expect(files.select(&:preservation?).count).to eq(1) # Sanity

        files.each do |f|
          expect(f.fits_output.present?).to eq f.preservation?
        end
      end
    end

    context 'when the change set does not support files' do
      let(:change_set) { Valkyrie::ChangeSet.new({}) }

      it 'returns Success' do
        expect(operation.call(change_set)).to be_success
      end
    end

    context 'with an unsuccessful save' do
      let(:mock_change_set) { instance_double(Work::SubmissionChangeSet) }
      let(:mock_adapter) { instance_double(IndexingAdapter) }

      before do
        allow(mock_change_set).to receive(:file).and_return('file')
        allow(operation).to receive(:metadata_adapter).and_return(mock_adapter)
        allow(mock_adapter).to receive(:persister).and_raise(StandardError, 'unsupported adapter')
      end

      it 'returns Failure' do
        expect {
          result = operation.call(mock_change_set)
          expect(result).to be_failure
          expect(result.failure.message).to eq('Error persisting file: unsupported adapter')
        }.to change { Work::File.count }.by(0)
      end
    end
  end
end
