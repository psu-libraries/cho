# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::File do
  describe '#type' do
    context 'with a preservation file' do
      subject { ImportFactory::File.create('workID_preservation.tif') }

      its(:type) { is_expected.to be(Valkyrie::Vocab::PCDMUse.PreservationMasterFile) }
    end

    context 'with an extracted text file' do
      subject { ImportFactory::File.create('workID_text.txt') }

      its(:type) { is_expected.to be(Valkyrie::Vocab::PCDMUse.ExtractedText) }
    end

    context 'with a redacted preservation file' do
      subject { ImportFactory::File.create('workID_preservation-redacted.tif') }

      its(:type) { is_expected.to be(Vocab::FileUse.RedactedPreservationMasterFile) }
    end

    context 'with an access file' do
      subject { ImportFactory::File.create('workID_access.jpg') }

      its(:type) { is_expected.to be(Vocab::FileUse.AccessFile) }
    end

    context 'with a service file' do
      subject { ImportFactory::File.create('workID_service.jp2') }

      its(:type) { is_expected.to be(Valkyrie::Vocab::PCDMUse.ServiceFile) }
    end

    context 'with a thumbnail image file' do
      subject { ImportFactory::File.create('workID_thumb.jpg') }

      its(:type) { is_expected.to be(Valkyrie::Vocab::PCDMUse.ThumbnailImage) }
    end

    context 'with a front image file' do
      subject { ImportFactory::File.create('workID_front.jpg') }

      its(:type) { is_expected.to be(Vocab::FileUse.FrontImage) }
    end

    context 'with a back image file' do
      subject { ImportFactory::File.create('workID_back.jpg') }

      its(:type) { is_expected.to be(Vocab::FileUse.BackImage) }
    end

    context 'with an unsupported type' do
      let(:file) { ImportFactory::File.create('workID_unsupported.jpg') }

      it 'raises an error' do
        expect {
          file.type
        }.to raise_error(Import::File::UnknownFileTypeError, 'workID_unsupported.jpg does not have a valid file type')
      end
    end
  end

  describe '#valid?' do
    context 'when the object id does not match the parent directory' do
      subject { ImportFactory::File.create('wrongID_preservation.tif', parent: 'workID') }

      it { is_expected.not_to be_valid }
    end

    context 'when the object does not have a valid file type' do
      subject { ImportFactory::File.create('workID_unsupported.jpg') }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#work_id' do
    subject { ImportFactory::File.create('workID_preservation.tif') }

    its(:work_id) { is_expected.to eq('workID') }
  end

  describe '#suffix' do
    subject { ImportFactory::File.create('workID_preservation.tif') }

    its(:suffix) { is_expected.to eq('preservation') }
  end

  describe '#file_set_id' do
    context 'with a simple file' do
      subject { ImportFactory::File.create('workID_preservation.tif') }

      its(:file_set_id) { is_expected.to be_nil }
    end

    context 'with a file in a set' do
      subject { ImportFactory::File.create('workID_0001_preservation.tif') }

      its(:file_set_id) { is_expected.to eq('workID_0001') }
    end
  end

  describe '#to_s' do
    subject { ImportFactory::File.create('workID_0001_preservation.tif') }

    its(:to_s) { is_expected.to eq('workID_0001_preservation.tif') }
  end

  describe '#path' do
    subject { ImportFactory::File.create('workID_0001_preservation.tif') }

    its(:path) { is_expected.to eq(Rails.root.join('tmp', 'workID', 'workID_0001_preservation.tif').to_s) }
  end

  describe '#service?' do
    context 'with a service file' do
      subject { ImportFactory::File.create('workID_0001_service.jp2') }

      it { is_expected.to be_service }
    end

    context 'with a non-service file' do
      subject { ImportFactory::File.create('workID_0001_preservation.tif') }

      it { is_expected.not_to be_service }
    end
  end

  describe '#preservation?' do
    context 'with a preservation file' do
      subject { ImportFactory::File.create('workID_0001_preservation.tif') }

      it { is_expected.to be_preservation }
    end

    context 'with a non-preservation file' do
      subject { ImportFactory::File.create('workID_0001_access.jpg') }

      it { is_expected.not_to be_preservation }
    end
  end

  describe '#representative?' do
    context 'with a representative file' do
      subject { ImportFactory::File.create('workID_preservation.tif') }

      it { is_expected.to be_representative }
    end

    context 'with a non-representative file' do
      subject { ImportFactory::File.create('workID_0001_access.jpg') }

      it { is_expected.not_to be_representative }
    end
  end
end
