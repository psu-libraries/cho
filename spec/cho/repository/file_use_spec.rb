# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::FileUse, type: :model do
  describe '#get_method' do
    context 'with a preservation file' do
      subject { described_class.new('PreservationMasterFile') }

      its(:get_method) { is_expected.to eq(:preservation) }
    end

    context 'with a redacted preservation file' do
      subject { described_class.new('RedactedPreservationMasterFile') }

      its(:get_method) { is_expected.to eq(:preservation_redacted) }
    end

    context 'with an access file' do
      subject { described_class.new('AccessFile') }

      its(:get_method) { is_expected.to eq(:access) }
    end

    context 'with a service file' do
      subject { described_class.new('ServiceFile') }

      its(:get_method) { is_expected.to eq(:service) }
    end

    context 'with a thumbnail file' do
      subject { described_class.new('ThumbnailImage') }

      its(:get_method) { is_expected.to eq(:thumb) }
    end

    context 'with an extracted text file' do
      subject { described_class.new('ExtractedText') }

      its(:get_method) { is_expected.to eq(:text) }
    end
  end

  describe '#set_method' do
    context 'with a preservation file' do
      subject { described_class.new('PreservationMasterFile') }

      its(:set_method) { is_expected.to eq(:preservation!) }
    end

    context 'with a redacted preservation file' do
      subject { described_class.new('RedactedPreservationMasterFile') }

      its(:set_method) { is_expected.to eq(:preservation_redacted!) }
    end

    context 'with an access file' do
      subject { described_class.new('AccessFile') }

      its(:set_method) { is_expected.to eq(:access!) }
    end

    context 'with a service file' do
      subject { described_class.new('ServiceFile') }

      its(:set_method) { is_expected.to eq(:service!) }
    end

    context 'with a thumbnail file' do
      subject { described_class.new('ThumbnailImage') }

      its(:set_method) { is_expected.to eq(:thumb!) }
    end

    context 'with an extracted text file' do
      subject { described_class.new('ExtractedText') }

      its(:set_method) { is_expected.to eq(:text!) }
    end
  end

  describe '#ask_method' do
    context 'with a preservation file' do
      subject { described_class.new('PreservationMasterFile') }

      its(:ask_method) { is_expected.to eq(:preservation?) }
    end

    context 'with a redacted preservation file' do
      subject { described_class.new('RedactedPreservationMasterFile') }

      its(:ask_method) { is_expected.to eq(:preservation_redacted?) }
    end

    context 'with an access file' do
      subject { described_class.new('AccessFile') }

      its(:ask_method) { is_expected.to eq(:access?) }
    end

    context 'with a service file' do
      subject { described_class.new('ServiceFile') }

      its(:ask_method) { is_expected.to eq(:service?) }
    end

    context 'with a thumbnail file' do
      subject { described_class.new('ThumbnailImage') }

      its(:ask_method) { is_expected.to eq(:thumb?) }
    end

    context 'with an extracted text file' do
      subject { described_class.new('ExtractedText') }

      its(:ask_method) { is_expected.to eq(:text?) }
    end
  end
end
