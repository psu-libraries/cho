# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvDryRun do
  let(:collection) { create :library_collection }
  let(:work_type_id) { Work::Type.find_using(label: 'Generic').first.id }
  let(:csv_data) { "member_of_collection_ids,work_type_id,title\n#{collection.id},#{work_type_id},\"My Awsome work\"" }

  let(:csv_file) do
    file = Tempfile.new('csv')
    file.write(csv_data)
    file.close
    file
  end

  let(:csv_file_name) { csv_file.path }

  after do
    csv_file.unlink
  end

  describe '#run' do
    subject(:dry_run_results) { described_class.run(csv_file_name) }

    it 'returns a list of change sets' do
      is_expected.to be_a Array
      expect(dry_run_results.count).to eq(1)
      expect(dry_run_results.first).to be_valid
      expect(dry_run_results.first.title).to eq('My Awsome work')
    end

    context 'invalid data' do
      let(:csv_data) { "member_of_collection_ids,work_type_id,title\n#{collection.id},#{work_type_id}," }

      it 'returns a list of change sets' do
        is_expected.to be_a Array
        expect(dry_run_results.count).to eq(1)
        expect(dry_run_results.first).not_to be_valid
      end
    end

    context 'valid and invalid data' do
      let(:csv_data) { "member_of_collection_ids,work_type_id,title\n#{collection.id},#{work_type_id},\n#{collection.id},#{work_type_id},\"My Awsome work\",\n#{collection.id},,\"My Awsome work\"" }

      it 'returns a list of change sets' do
        is_expected.to be_a Array
        expect(dry_run_results.count).to eq(3)
        expect(dry_run_results[0]).not_to be_valid
        expect(dry_run_results[1]).to be_valid
        expect(dry_run_results[2]).not_to be_valid
      end
    end
  end
end
