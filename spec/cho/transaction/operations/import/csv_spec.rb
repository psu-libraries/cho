# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Import::Csv do
  describe '#call' do
    context 'when the csv import fails for an unexpected reason' do
      before do
        allow(Work::Import::CsvDryRun).to receive(:new).and_raise(StandardError, 'Something unexpected occurred')
      end

      it 'returns a failure' do
        result = described_class.new.call(csv_dry_run: Work::Import::CsvDryRun, file: 'file', update: false)
        expect(result).to be_failure
        expect(result.failure).to eq(['Something unexpected occurred'])
      end
    end
  end
end
