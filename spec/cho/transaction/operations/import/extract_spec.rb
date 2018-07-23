# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Import::Extract do
  let(:operation) { described_class.new }

  describe '#call' do
    context 'when the zip file is successfully extracted' do
      let(:bag_path) { Pathname.new(ENV['extraction_directory']).expand_path.join('sample_zip') }

      before do
        FileUtils.rm_rf(bag_path)
        @network_ingest_directory = ENV['network_ingest_directory']
        ENV['network_ingest_directory'] = fixture_path
      end

      after do
        ENV['network_ingest_directory'] = @network_ingest_directory
      end

      it 'extracts the zip and returns Success' do
        result = operation.call('sample_zip')
        expect(result).to be_success
        expect(result.success).to eq(bag_path)
        expect(bag_path).to be_directory
        expect(bag_path.join('data')).to be_directory
        expect(bag_path.join('data', 'sample_object.txt')).to be_file
        expect(bag_path.join('sample_file.txt')).to be_file
      end
    end

    context 'when the zip cannot be extracted' do
      let(:path) { Rails.root.join('tmp', 'ingest-test', 'non-existent zip.zip') }

      it 'returns Failure' do
        result = operation.call('non-existent zip')
        expect(result).to be_failure
        expect(result.failure).to eq(
          "Error exacting the bag: File #{path} not found"
        )
      end
    end
  end
end
