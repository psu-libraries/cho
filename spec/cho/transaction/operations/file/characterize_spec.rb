# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::Characterize do
  let(:operation) { described_class.new }
  let(:collection) { create(:collection) }
  let(:change_set) { Work::FileChangeSet.new(resource) }
  let(:fits_output) {
    "<identification>\r\n"\
    "    <identity format=\"Plain text\" mimetype=\"text/plain\" toolname=\"FITS\" toolversion=\"1.2.0\">\r\n"\
    "      <tool toolname=\"Droid\" toolversion=\"6.3\" />\r\n"\
    "      <tool toolname=\"Jhove\" toolversion=\"1.16\" />\r\n"\
    "      <tool toolname=\"file utility\" toolversion=\"5.31\" />\r\n"\
    "      <externalIdentifier toolname=\"Droid\" toolversion=\"6.3\" type=\"puid\">x-fmt/111</externalIdentifier>\r\n"\
    "    </identity>\r\n"\
    '  </identification>'
  }

  describe '#call' do
    context 'with a file' do
      let(:resource) { Work::File.all.first }
      let(:work_resource) { build(:work, title: 'with a file', member_of_collection_ids: [collection.id]) }
      let(:work_change_set) { Work::SubmissionChangeSet.new(work_resource) }
      let(:temp_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt')) }
      let(:resource_params) { { label: 'abc123', file: temp_file } }

      before do
        mock_fits_for_travis
        work_change_set.validate(resource_params)
        Transaction::File::Create.new.call(work_change_set)
      end

      it 'returns Success' do
        result = operation.call(change_set)
        expect(result).to be_success
        expect(result.success).to eq(change_set)
        expect(change_set.fits_output).to include(fits_output)
      end
    end
    context 'without a file' do
      let(:resource_params) { { label: 'abc123' } }
      let(:resource) { Work::File.new }

      it 'returns Failure' do
        result = operation.call(change_set)
        expect(result).to be_failure
        expect(result.failure).to eq('Error characterizing file: Valkyrie::StorageAdapter::FileNotFound')
      end
    end

    def mock_fits_for_travis
      return unless ENV['TRAVIS']

      allow(Hydra::FileCharacterization).to receive(:characterize).and_return(fits_output)
    end
  end
end
