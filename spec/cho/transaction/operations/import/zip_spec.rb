# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Import::Zip do
  let(:operation) { described_class.new }
  let(:change_set) { double('A Change Set', file: file) }
  let(:file) { instance_spy('Import::File') }

  describe '#call' do
    context 'when an error happens' do
      let(:mock_import_from_zip) { instance_double('Transaction::Import::ImportFromZip') }

      before do
        allow(Transaction::Import::ImportFromZip)
          .to receive(:new)
          .and_return(mock_import_from_zip)

        allow(mock_import_from_zip)
          .to receive(:call)
          .and_raise('strewth!')
      end

      it 'returns a Failure' do
        result = operation.call(change_set)
        expect(result).to be_failure
      end
    end
  end
end
