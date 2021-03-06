# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::FileSet do
  subject { described_class.new(files) }

  describe '#representative' do
    context 'with representative files' do
      let(:files) { [ImportFactory::File.create('work1234_pdf.tif')] }

      it { is_expected.to be_representative }
    end

    context 'without representative files' do
      let(:files) { [ImportFactory::File.create('work1234_0001_preservation.tif')] }

      it { is_expected.not_to be_representative }
    end

    context 'with a representative of a multipart work id' do
      let(:files) { [ImportFactory::File.create('work12_34_0001_preservation.tif', parent: 'work12_34')] }

      it { is_expected.not_to be_representative }
    end

    context 'with a non-representative of a multipart work id' do
      let(:files) { [ImportFactory::File.create('work12_34_preservation.tif', parent: 'work12_34')] }

      it { is_expected.not_to be_representative }
    end
  end

  describe '#id' do
    context 'with a simple file' do
      let(:files) { [ImportFactory::File.create('work1234_0001_preservation.tif')] }

      its(:id) { is_expected.to eq('work1234_0001') }
    end

    context 'with a multipart work id' do
      let(:files) { [ImportFactory::File.create('work12_34_0001_preservation.tif', parent: 'work12_34')] }

      its(:id) { is_expected.to eq('work12_34_0001') }
    end
  end

  describe '#to_s' do
    let(:file_set) { described_class.new('file') }

    it 'is aliased to id' do
      expect(file_set.method(:to_s)).to eq(file_set.method(:id))
    end
  end

  describe '#title' do
    context 'with a preservation file' do
      let(:files) { [ImportFactory::File.create('work1234_0001_preservation.tif')] }

      its(:title) { is_expected.to eq('work1234_0001_preservation.tif') }
    end

    context 'with an access file' do
      let(:files) { [ImportFactory::File.create('work1234_0001_access.jpg')] }

      its(:title) { is_expected.to eq('work1234_0001_access.jpg') }
    end

    context 'with neither access nor preservation files' do
      let(:files) { [ImportFactory::File.create('work1234_0001_service.jpg')] }

      its(:title) { is_expected.to be_nil }
    end
  end
end
