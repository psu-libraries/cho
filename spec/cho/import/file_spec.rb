# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::File do
  describe '#type' do
    context 'with a preservation file' do
      subject { ImportFactory::File.create('work_ID_preservation.tif', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.PreservationMasterFile) }
    end

    context 'with an extracted text file' do
      subject { ImportFactory::File.create('work_ID_text.txt', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.ExtractedText) }
    end

    context 'with a redacted preservation file' do
      subject { ImportFactory::File.create('work_ID_preservation-redacted.tif', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.RedactedPreservationMasterFile) }
    end

    context 'with an access file' do
      subject { ImportFactory::File.create('work_ID_access.jpg', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.AccessFile) }
    end

    context 'with a service file' do
      subject { ImportFactory::File.create('work_ID_service.jp2', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.ServiceFile) }
    end

    context 'with a thumbnail image file' do
      subject { ImportFactory::File.create('work_ID_thumb.jpg', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.ThumbnailImage) }
    end

    context 'with a front image file' do
      subject { ImportFactory::File.create('work_ID_front.jpg', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.FrontImage) }
    end

    context 'with a back image file' do
      subject { ImportFactory::File.create('work_ID_back.jpg', parent: 'work_ID') }

      its(:type) { is_expected.to be(Vocab::FileUse.BackImage) }
    end

    context 'with an unsupported type' do
      let(:file) { ImportFactory::File.create('work_ID_unsupported.jpg', parent: 'work_ID') }

      it 'raises an error' do
        expect {
          file.type
        }.to raise_error(Import::File::UnknownFileTypeError, 'work_ID_unsupported.jpg does not have a valid file type')
      end
    end
  end

  describe '#valid?' do
    context 'when the object id does not match the parent directory' do
      subject { ImportFactory::File.create('wrongID_preservation.tif', parent: 'work_ID') }

      it { is_expected.not_to be_valid }
    end

    context 'when the object does not have a valid file type' do
      subject { ImportFactory::File.create('work_ID_unsupported.jpg', parent: 'work_ID') }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#work_id' do
    subject { ImportFactory::File.create('work_ID_preservation.tif', parent: 'work_ID') }

    its(:work_id) { is_expected.to eq('work_ID') }
  end

  describe '#suffix' do
    subject { ImportFactory::File.create('work_ID_preservation.tif', parent: 'work_ID') }

    its(:suffix) { is_expected.to eq('preservation') }
  end

  describe '#file_set_id' do
    context 'with a simple file' do
      subject { ImportFactory::File.create('work_ID_preservation.tif', parent: 'work_ID') }

      its(:file_set_id) { is_expected.to be_nil }
    end

    context 'with a file in a set' do
      subject { ImportFactory::File.create('work_ID_0001_preservation.tif', parent: 'work_ID') }

      its(:file_set_id) { is_expected.to eq('work_ID_0001') }
    end

    context 'with a complex work and file set' do
      subject { ImportFactory::File.create('xyz_1234_work_ID_0001_03_preservation.tif', parent: 'xyz_1234_work_ID') }

      its(:file_set_id) { is_expected.to eq('xyz_1234_work_ID_0001_03') }
    end
  end

  describe '#to_s' do
    subject { ImportFactory::File.create('work_ID_0001_preservation.tif', parent: 'work_ID') }

    its(:to_s) { is_expected.to eq('work_ID_0001_preservation.tif') }
  end

  describe '#path' do
    subject { ImportFactory::File.create('work_ID_0001_preservation.tif', parent: 'work_ID') }

    its(:path) { is_expected.to eq(ImportFactory::Bag.root.join('work_ID', 'work_ID_0001_preservation.tif').to_s) }
  end

  describe '#service?' do
    context 'with a service file' do
      subject { ImportFactory::File.create('work_ID_0001_service.jp2', parent: 'work_ID') }

      it { is_expected.to be_service }
    end

    context 'with a non-service file' do
      subject { ImportFactory::File.create('work_ID_0001_preservation.tif', parent: 'work_ID') }

      it { is_expected.not_to be_service }
    end

    context 'with an unsupported file type' do
      subject { ImportFactory::File.create('work_ID_0001_foo.tif', parent: 'work_ID') }

      it { is_expected.not_to be_service }
    end
  end

  describe '#access?' do
    context 'with an access file' do
      subject { ImportFactory::File.create('work_ID_0001_access.jp2', parent: 'work_ID') }

      it { is_expected.to be_access }
    end

    context 'with a non-access file' do
      subject { ImportFactory::File.create('work_ID_0001_preservation.tif', parent: 'work_ID') }

      it { is_expected.not_to be_access }
    end

    context 'with an unsupported file type' do
      subject { ImportFactory::File.create('work_ID_0001_foo.tif', parent: 'work_ID') }

      it { is_expected.not_to be_access }
    end
  end

  describe '#preservation?' do
    context 'with a preservation file' do
      subject { ImportFactory::File.create('work_ID_0001_preservation.tif', parent: 'work_ID') }

      it { is_expected.to be_preservation }
    end

    context 'with a non-preservation file' do
      subject { ImportFactory::File.create('work_ID_0001_access.jpg', parent: 'work_ID') }

      it { is_expected.not_to be_preservation }
    end

    context 'with an unsupported file type' do
      subject { ImportFactory::File.create('work_ID_0001_foo.tif', parent: 'work_ID') }

      it { is_expected.not_to be_preservation }
    end
  end

  describe '#representative?' do
    context 'with a representative file' do
      subject { ImportFactory::File.create('work_ID_preservation.tif', parent: 'work_ID') }

      it { is_expected.to be_representative }
    end

    context 'with a non-representative file' do
      subject { ImportFactory::File.create('work_ID_0001_access.jpg', parent: 'work_ID') }

      it { is_expected.not_to be_representative }
    end
  end
end
