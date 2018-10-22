# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::Characterize do
  let(:operation) { described_class.new }
  let(:collection) { create(:collection) }
  let(:change_set) { Work::FileChangeSet.new(resource) }
  let(:fits_output) { File.read(Pathname.new(fixture_path).join('fits_output.xml')) }

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
        Transaction::Operations::File::Save.new.call(work_change_set)
      end

      it 'returns Success' do
        result = operation.call(change_set)
        expect(result).to be_success
        expect(result.success).to eq(change_set)
        document = Capybara::Node::Simple.new(change_set.fits_output)
        expect(document).to have_xpath('//identification/identity[@toolname="FITS"]')
        expect(document).to have_xpath('//identification/identity/tool[@toolname="Droid"]')
        expect(document).to have_xpath('//identification/identity/tool[@toolname="Jhove"]')
        expect(document).to have_xpath('//identification/identity/tool[@toolname="file utility"]')
        expect(document).to have_xpath('//externalidentifier')
      end
    end
    context 'without a file' do
      let(:resource_params) { { label: 'abc123' } }
      let(:resource) { Work::File.new }

      it 'returns Failure' do
        result = operation.call(change_set)
        expect(result).to be_failure
        expect(result.failure.message).to eq('Error characterizing file: Valkyrie::StorageAdapter::FileNotFound')
      end
    end

    def mock_fits_for_travis
      return unless ENV['TRAVIS']

      allow(Hydra::FileCharacterization).to receive(:characterize).and_return(fits_output)
    end
  end
end
