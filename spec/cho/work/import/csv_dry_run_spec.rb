# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvDryRun do
  let(:collection) { create :library_collection }
  let(:work_type_id) { Work::Type.find_using(label: 'Generic').first.id }
  let(:update) { false }

  describe '#update?' do
    before do
      allow(File).to receive(:new).with('path', 'r')
      allow(Work::Import::CsvReader).to receive(:new).with(any_args).and_return(mock_reader)
    end

    context 'by default' do
      subject { described_class.new('path') }

      let(:mock_reader) { instance_double(Work::Import::CsvReader, headers: [], map: []) }

      it { is_expected.not_to be_update }
    end

    context 'when set to true' do
      subject { described_class.new('path', update: true) }

      let(:mock_reader) { instance_double(Work::Import::CsvReader, headers: ['id'], map: []) }

      it { is_expected.to be_update }
    end
  end

  describe '#results' do
    subject(:dry_run_results) { described_class.new(csv_file.path, update: update).results }

    after { csv_file.unlink }

    context 'with valid data' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          member_of_collection_ids: [collection.id], work_type_id: [work_type_id], title: ['My Awesome Work']
        )
      end

      it 'returns a list of change sets' do
        is_expected.to be_a Array
        expect(dry_run_results.count).to eq(1)
        expect(dry_run_results.first).to be_valid
        expect(dry_run_results.first.title).to eq('My Awesome Work')
      end
    end

    context 'invalid data' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          member_of_collection_ids: [collection.id], work_type_id: [work_type_id], title: [nil]
        )
      end

      it 'returns a list of change sets' do
        is_expected.to be_a Array
        expect(dry_run_results.count).to eq(1)
        expect(dry_run_results.first).not_to be_valid
      end
    end

    context 'valid and invalid data' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          member_of_collection_ids: [collection.id, collection.id, collection.id],
          work_type_id: [work_type_id, work_type_id, nil],
          title: [nil, 'My Awesome Work', 'My Awesome Work']
        )
      end

      it 'returns a list of change sets' do
        is_expected.to be_a Array
        expect(dry_run_results.count).to eq(3)
        expect(dry_run_results[0]).not_to be_valid
        expect(dry_run_results[1]).to be_valid
        expect(dry_run_results[2]).not_to be_valid
      end
    end

    context 'Work Type string included ' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          member_of_collection_ids: [collection.id, collection.id, collection.id],
          work_type: ['Generic', 'Generic', 'Generic'],
          title: ['My Stuff', 'My Awesome Work', 'My Awesome Work']
        )
      end

      it 'returns a list of change sets' do
        is_expected.to be_a Array
        expect(dry_run_results.count).to eq(3)
        expect(dry_run_results[0]).to be_valid
        expect(dry_run_results[1]).to be_valid
        expect(dry_run_results[2]).to be_valid
      end
    end

    context 'Work Type string included ' do
      let(:file_name) { Rails.root.join('spec', 'fixtures', 'hello_world.txt') }

      let(:csv_file) do
        CsvFactory::Generic.new(
          member_of_collection_ids: [collection.id], work_type: ['Generic'], title: ['My Stuff'], file_name: [file_name]
        )
      end

      it 'returns a list of change sets' do
        is_expected.to be_a Array
        expect(dry_run_results.count).to eq(1)
        expect(dry_run_results[0]).to be_valid
        expect(dry_run_results[0].file).to be_a(ActionDispatch::Http::UploadedFile)
      end
    end

    context 'with columns not in the data dictionary' do
      let(:csv_file) do
        CsvFactory::Generic.new(
          member_of_collection_ids: [collection.id, collection.id],
          work_type: ['Generic', 'Generic'],
          title: ['My Work 1', 'My Work 2'],
          invalid_column: ['bad value 1', nil]
        )
      end

      it 'raises an error' do
        expect { dry_run_results }.to raise_error(
          Work::Import::CsvDryRun::InvalidCsvError, "Unexpected column(s): 'invalid_column'"
        )
      end
    end

    context 'without an id column during an update' do
      let(:update) { true }

      let(:csv_file) do
        CsvFactory::Generic.new(
          member_of_collection_ids: [collection.id], work_type: ['Generic'], title: ['My Stuff']
        )
      end

      it 'raises an error' do
        expect { dry_run_results }.to raise_error(
          Work::Import::CsvDryRun::InvalidCsvError, 'Missing id column for update'
        )
      end
    end
  end
end
