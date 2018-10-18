# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::FileSet::ExtractText do
  let(:operation) { described_class.new }

  describe '#call' do
    let(:file_set) { create(:file_set, :with_member_file) }

    context 'with a successful save' do
      it 'returns Success' do
        file_set # initialize the file_set before the expect so the count is for the extracted text
        expect {
          result = operation.call(file_set)
          expect(result).to be_success
          expect(result.success).to eq(file_set)
          expect(result.success.member_ids.count).to eq(2)
          files = result.success.member_ids.map { |id| Work::File.find(id) }
          expect(files.map(&:use)).to eq([[Valkyrie::Vocab::PCDMUse.PreservationMasterFile],
                                          [Valkyrie::Vocab::PCDMUse.ExtractedText]])
          expect(File.read(files[1].path)).to eq("\n\n\n\n\n\n\n\n\n\nHello World!")
        }.to change { Work::File.count }.by(1)
      end
    end

    context 'with an unsuccessful save' do
      let(:mock_operation) { instance_double(Transaction::Operations::File::Create) }

      before do
        file_set # initializing before the mock
        allow(Transaction::Operations::File::Create).to receive(:new).and_return(mock_operation)
        allow(mock_operation).to receive(:call).and_return(Dry::Monads::Result::Failure.new('unsuccessful save'))
      end

      it 'returns Failure' do
        expect {
          result = operation.call(file_set)
          expect(result).to be_failure
          expect(result.failure.message).to eq('Error extracting text: unsuccessful save')
        }.to change { Work::File.count }.by(0)
      end
    end

    context 'when the operation fails' do
      before do
        file_set # initializing before the mock
        allow(operation).to receive(:store_text).and_raise(StandardError, 'operation failed')
      end

      it 'returns Failure' do
        expect {
          result = operation.call(file_set)
          expect(result).to be_failure
          expect(result.failure.message).to eq('Error extracting text: operation failed')
        }.to change { Work::File.count }.by(0)
      end
    end
  end
end
