# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Work do
  describe 'a simple work' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          'workID_preservation.tif',
          'workID_preservation-redacted.tif',
          'workID_service.jp2',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).to be_valid
      expect(work.errors).to be_empty
      expect(work.files.count).to eq(5)
      expect(work.nested_works.count).to eq(0)
      expect(work.file_sets.count).to eq(1)
      expect(work.file_sets.first).not_to be_representative
      expect(work.path).to eq(ImportFactory::Bag.root.join('workID'))
      expect(work.identifier).to eq('workID')
    end
  end

  describe 'a multi-page work' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          'workID_00001_01_preservation.tif',
          'workID_00001_01_preservation-redacted.tif',
          'workID_00001_01_service.jp2',
          'workID_00001_02_preservation.tif',
          'workID_00001_02_service.jp2',
          'workID_00002_01_preservation.tif',
          'workID_00002_01_service.jp2',
          'workID_00002_02_preservation.tif',
          'workID_00002_02_service.jp2',
          'workID_access.pdf',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).to be_valid
      expect(work.errors).to be_empty
      expect(work.files.count).to eq(12)
      expect(work.nested_works.count).to eq(0)
      expect(work.file_sets.map(&:id)).to include(
        'workID_00001_01',
        'workID_00001_02',
        'workID_00002_01',
        'workID_00002_02',
        nil
      )
      expect(work.representative).to be_representative
      expect(work.representative.files.map(&:original_filename)).to include(
        'workID_access.pdf', 'workID_text.txt', 'workID_thumb.jpg'
      )
    end
  end

  describe 'a two-sided audio recording' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          'workID_00001_preservation.wav',
          'workID_00001_front.jpg',
          'workID_00002_preservation.wav',
          'workID_00002_back.jpg',
          'workID_service.flac',
          'workID_access.mp3',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).to be_valid
      expect(work.errors).to be_empty
      expect(work.files.count).to eq(8)
      expect(work.nested_works.count).to eq(0)
      expect(work.file_sets.map(&:id)).to include('workID_00001', 'workID_00002', nil)
      expect(work.representative).to be_representative
      expect(work.representative.files.map(&:original_filename)).to include(
        'workID_service.flac', 'workID_access.mp3', 'workID_text.txt', 'workID_thumb.jpg'
      )
    end
  end

  describe 'a folder of manuscript materials' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          {
            workID_00001: [
              'workID_00001_01_preservation.tif',
              'workID_00001_01_preservation-redacted.tif',
              'workID_00001_01_service.jp2',
              'workID_00001_01_thumb.jpg',
              'workID_00001_02_preservation.tif',
              'workID_00001_02_service.jp2',
              'workID_00001_02_thumb.jpg'
            ]
          },
          {
            workID_00002: [
              'workID_00002_01_preservation.tif',
              'workID_00002_01_service.jp2',
              'workID_00002_01_thumb.jpg',
              'workID_00002_02_preservation.tif',
              'workID_00002_02_service.jp2',
              'workID_00002_02_thumb.jpg'
            ]
          },
          'workID_access.pdf',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).to be_valid
      expect(work.errors).to be_empty
      expect(work.files.count).to eq(3)
      expect(work.file_sets.count).to eq(1)
      expect(work.file_sets.first).to be_representative
      expect(work.nested_works.count).to eq(2)
      expect(work.nested_works.first.files.count).to eq(7)
      expect(work.nested_works.first.file_sets.count).to eq(2)
      work.nested_works.first.file_sets.each do |file_set|
        expect(file_set).not_to be_representative
      end
      expect(work.nested_works.last.files.count).to eq(6)
      expect(work.nested_works.last.file_sets.count).to eq(2)
      work.nested_works.last.file_sets.each do |file_set|
        expect(file_set).not_to be_representative
      end
    end
  end

  describe 'a two-sided audio recording' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          {
            workID_00001: [
              'workID_00001_front.jpg',
              'workID_00001_preservation.wav',
              'workID_00001_service.flac'
            ]
          },
          {
            workID_00002: [
              'workID_00002_back.jpg',
              'workID_00002_preservation.wav',
              'workID_00002_service.flac'
            ]
          },
          'workID_service.flac',
          'workID_access.mp3',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).to be_valid
      expect(work.errors).to be_empty
      expect(work.files.count).to eq(4)
      expect(work.file_sets.count).to eq(1)
      expect(work.file_sets.first).to be_representative
      expect(work.nested_works.count).to eq(2)
      expect(work.nested_works.first.files.count).to eq(3)
      expect(work.nested_works.first.file_sets.count).to eq(1)
      expect(work.nested_works.first.file_sets.first).not_to be_representative
      expect(work.nested_works.last.files.count).to eq(3)
      expect(work.nested_works.last.file_sets.count).to eq(1)
      expect(work.nested_works.last.file_sets.first).not_to be_representative
    end
  end

  describe 'a work with a invalid file type' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          'workID_preservation.tif',
          'workID_preservation-redacted.tif',
          'workID_unsupported.jp2',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).not_to be_valid
      expect(work.errors.messages).to include(
        files: ['Import file workID_unsupported.jp2 does not have a valid file type']
      )
      expect(work.files.count).to eq(5)
      expect(work.nested_works.count).to eq(0)
      expect(work.file_sets.count).to eq(1)
    end
  end

  describe 'a work with a incorrect file object id' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          'workID_preservation.tif',
          'workID_preservation-redacted.tif',
          'wrongID.jp2',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).not_to be_valid
      expect(work.errors.messages).to include(
        files: [
          'Import file wrongID.jp2 does not match the parent directory',
          'Import file wrongID.jp2 does not have a valid file type'
        ]
      )
      expect(work.files.count).to eq(5)
      expect(work.nested_works.count).to eq(0)
      expect(work.file_sets.count).to eq(2)
    end
  end

  describe 'a work with an invalid representative file set' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          'workID_preservation-redacted.tif',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).not_to be_valid
      expect(work.errors.messages).to include(file_sets: ['representative does not have an access file'])
    end
  end

  describe 'a work with an invalid file set' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          'workID_00001_01_preservation-redacted.tif',
          'workID_00001_01_access.jp2',
          'workID_00001_02_preservation.tif',
          'workID_00001_02_service.jp2',
          'workID_access.pdf',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      expect(work).not_to be_valid
      expect(work.errors.messages).to include(
        file_sets: ['workID_00001_01 does not have a service or preservation file']
      )
    end
  end

  describe 'an invalid nested work' do
    subject(:work) do
      ImportFactory::Work.create(
        workID: [
          {
            workID_00001: [
              'workID_00001_front.jpg',
              'badID_00001_preservation.wav',
              'workID_00001_service.flac'
            ]
          },
          {
            workID_00002: [
              'workID_00002_back.jpg',
              'workID_00002_unsupported.wav',
              'workID_00002_service.flac'
            ]
          },
          'workID_service.flac',
          'workID_access.mp3',
          'workID_text.txt',
          'workID_thumb.jpg'
        ]
      )
    end

    it do
      pending('See: https://github.com/psu-libraries/cho/issues/757 Validate bags with nested works')
      expect(work).not_to be_valid
      expect(work.errors).to be_empty
      expect(work.files.count).to eq(4)
      expect(work.file_sets.count).to eq(1)
      expect(work.nested_works.count).to eq(2)
      expect(work.nested_works.first.files.count).to eq(3)
      expect(work.nested_works.first.file_sets.count).to eq(1)
      expect(work.nested_works.last.files.count).to eq(3)
      expect(work.nested_works.last.file_sets.count).to eq(1)
    end
  end
end
