# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::CreateTempFile do
  let(:operation) { described_class.new }

  describe '#call' do
    subject(:result) { operation.call(io) }

    let(:io) { StringIO.new('abc 123') }

    it 'returns Success' do
      expect(result).to be_success
      expect(result.success.class).to eq(Tempfile)
      expect(result.success.read).to eq('abc 123')
    end

    context 'bad io' do
      let(:io) { nil }

      it 'returns Failure' do
        expect(result).to be_failure
        expect(result.failure).to eq('Error persisting file: undefined method `eof?\' for nil:NilClass')
      end
    end
  end
end
