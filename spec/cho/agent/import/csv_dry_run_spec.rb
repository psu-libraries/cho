# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::Import::CsvDryRun do
  let(:update) { false }

  describe '#update?' do
    before do
      allow(File).to receive(:new).with('path', 'r')
      allow(Csv::Reader).to receive(:new).with(any_args).and_return(mock_reader)
    end

    context 'by default' do
      subject { described_class.new('path') }

      let(:mock_reader) { instance_double(Csv::Reader, headers: [], map: []) }

      it { is_expected.not_to be_update }
    end

    context 'when set to true' do
      subject { described_class.new('path', update: true) }

      let(:mock_reader) { instance_double(Csv::Reader, headers: ['id'], map: []) }

      it { is_expected.to be_update }
    end
  end

  describe '#results' do
    subject(:dry_run_results) { described_class.new(csv_file.path, update: update).results }

    after { csv_file.unlink }

    context 'with valid data' do
      let(:csv_file) do
        CsvFactory::Generic.new(given_name: ['John', 'Jane'], surname: ['Doe', 'Smith'])
      end

      it 'returns a list of change sets' do
        expect(dry_run_results).to be_a Array
        expect(dry_run_results.count).to eq(2)
        expect(dry_run_results.first).to be_valid
        expect(dry_run_results.first.given_name).to eq('John')
        expect(dry_run_results.first.surname).to eq('Doe')
      end
    end

    context 'with invalid data' do
      let(:csv_file) do
        CsvFactory::Generic.new(given_name: ['John'], surname: [''])
      end

      it 'returns a list of change sets' do
        expect(dry_run_results).to be_a Array
        expect(dry_run_results.count).to eq(1)
        expect(dry_run_results.first).not_to be_valid
      end
    end

    context 'with both valid and invalid data' do
      let(:csv_file) do
        CsvFactory::Generic.new(given_name: ['John', ''], surname: ['Doe', 'Smith'])
      end

      it 'returns a list of change sets' do
        expect(dry_run_results).to be_a Array
        expect(dry_run_results.count).to eq(2)
        expect(dry_run_results[0]).to be_valid
        expect(dry_run_results[1]).not_to be_valid
      end
    end

    context 'with columns not in the data dictionary' do
      let(:csv_file) do
        CsvFactory::Generic.new(given_name: ['John', 'Jane'], surname: ['Doe', 'Smith'], invalid_column: ['1', '2'])
      end

      it 'raises an error' do
        expect { dry_run_results }.to raise_error(
          Csv::ValidationError, "Unexpected column(s): 'invalid_column'"
        )
      end
    end

    context 'without an id column during an update' do
      let(:update) { true }

      let(:csv_file) do
        CsvFactory::Generic.new(given_name: ['John', 'Jane'], surname: ['Doe', 'Smith'])
      end

      it 'raises an error' do
        expect { dry_run_results }.to raise_error(
          Csv::ValidationError, 'Missing id column for update'
        )
      end
    end
  end
end
