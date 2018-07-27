# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Import::Validate do
  let(:operation) { described_class.new }

  describe '#call' do
    context 'with a valid bag' do
      let(:bag) do
        ImportFactory::Bag.create(
          batch_id: 'batchID_2008-07-12',
          data: {
            workID: [
              'workID_01_preservation.tif',
              'workID_01_service.jp2'
            ]
          }
        )
      end

      it 'returns Success' do
        result = operation.call(bag.path)
        expect(result).to be_success
        expect(result.success).to be_a(Import::Bag)
        expect(result.success).to be_valid
      end
    end

    context 'with an invalid bag' do
      let(:bag) do
        ImportFactory::Bag.create(
          batch_id: 'batchID_2008-07-12',
          data: {
            workID: [
              'badID_01_preservation.tif',
              'workID_01_service.jp2'
            ]
          }
        )
      end

      it 'returns Failure' do
        result = operation.call(bag.path)
        expect(result).to be_failure
        expect(result.failure).to be_a(Import::Bag)
        expect(result.failure).not_to be_valid
        expect(result.failure.errors.messages).to include(
          works: ['Import file badID_01_preservation.tif does not match the parent directory']
        )
      end
    end

    context 'with an exception' do
      before do
        allow(Import::Bag).to receive(:new).with('bag_path')
          .and_raise(StandardError, 'bag_path is malformed')
      end

      it 'returns a Failure' do
        result = operation.call('bag_path')
        expect(result).to be_failure
        expect(result.failure).to eq('Error validating the bag: bag_path is malformed')
      end
    end
  end
end
