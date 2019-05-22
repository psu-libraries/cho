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

  describe '::uri_from_suffix' do
    subject { described_class.uri_from_suffix(suffix) }

    context 'with a preservation suffix' do
      let(:suffix) { 'preservation' }

      it { is_expected.to eq(Vocab::FileUse.PreservationMasterFile) }
    end

    context 'with a redacted preservation suffix' do
      let(:suffix) { 'preservation-redacted' }

      it { is_expected.to eq(Vocab::FileUse.RedactedPreservationMasterFile) }
    end

    context 'with an access suffix' do
      let(:suffix) { 'access' }

      it { is_expected.to eq(Vocab::FileUse.AccessFile) }
    end

    context 'with a service suffix' do
      let(:suffix) { 'service' }

      it { is_expected.to eq(Vocab::FileUse.ServiceFile) }
    end

    context 'with a thumbnail suffix' do
      let(:suffix) { 'thumb' }

      it { is_expected.to eq(Vocab::FileUse.ThumbnailImage) }
    end

    context 'with an extracted text suffix' do
      let(:suffix) { 'text' }

      it { is_expected.to eq(Vocab::FileUse.ExtractedText) }
    end
  end

  describe '::suffix_from_uri' do
    subject { described_class.suffix_from_uri(uri) }

    context 'with a preservation uri' do
      let(:uri) { Vocab::FileUse.PreservationMasterFile }

      it { is_expected.to eq('preservation') }
    end

    context 'with a redacted preservation uri' do
      let(:uri) { Vocab::FileUse.RedactedPreservationMasterFile }

      it { is_expected.to eq('preservation-redacted') }
    end

    context 'with an access uri' do
      let(:uri) { Vocab::FileUse.AccessFile }

      it { is_expected.to eq('access') }
    end

    context 'with a service uri' do
      let(:uri) { Vocab::FileUse.ServiceFile }

      it { is_expected.to eq('service') }
    end

    context 'with a thumbnail uri' do
      let(:uri) { Vocab::FileUse.ThumbnailImage }

      it { is_expected.to eq('thumb') }
    end

    context 'with an extracted text uri' do
      let(:uri) { Vocab::FileUse.ExtractedText }

      it { is_expected.to eq('text') }
    end
  end
end
