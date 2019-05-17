# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::Process do
  let(:operation) { described_class.new }
  let(:change_set) { double('A Change Set') }

  describe '#call' do
    context 'when the file is a zip' do
      let(:mock_zip_import) { instance_spy('Transaction::Operations::Import::Zip') }

      before do
        allow(change_set)
          .to receive_message_chain(:file, :content_type)
          .and_return('application/zip')

        allow(Mime::Type).to receive(:lookup)
          .with('application/zip')
          .and_return(instance_double('Mime::Type', symbol: :zip))

        allow(Transaction::Operations::Import::Zip).to receive(:new).and_return(mock_zip_import)
      end

      it 'delegates to Transaction::Operations::Import::Zip' do
        expect(mock_zip_import).to receive(:call).with(change_set)
        operation.call(change_set)
      end
    end

    context 'when the file is anything but a zip' do
      let(:mock_file_save) { instance_spy('Transaction::Operations::File::Save') }

      before do
        allow(change_set)
          .to receive_message_chain(:file, :content_type)
          .and_return('text/plain')

        allow(Mime::Type).to receive(:lookup)
          .with('text/plain')
          .and_return(instance_double('Mime::Type', symbol: :txt))

        allow(Transaction::Operations::File::Save).to receive(:new).and_return(mock_file_save)
      end

      it 'delegates to Transaction::Operations::File::Save' do
        expect(mock_file_save).to receive(:call).with(change_set)
        operation.call(change_set)
      end
    end

    context 'without a file' do
      before { allow(change_set).to receive(:file).and_return(nil) }

      it 'returns Success immediately' do
        result = operation.call(change_set)
        expect(result).to be_success
      end
    end

    context 'when something raises an error' do
      before { allow(change_set).to receive(:file).and_raise('crikey!') }

      it 'returns a Failure' do
        result = operation.call(change_set)
        expect(result).to be_failure
      end
    end
  end
end
