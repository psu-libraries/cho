# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::Bag do
  describe 'a valid bag' do
    subject(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batchID_2008-06-23',
        data: {
          workID: [
            'workID_preservation.tif',
            'workID_preservation-redacted.tif',
            'workID_service.jp2',
            'workID_text.txt',
            'workID_thumb.jpg'
          ]
        }
      )
    end

    it do
      expect(bag).to be_valid
      expect(bag.errors).to be_empty
      expect(bag.date).to eq('2008-06-23')
      expect(bag.batch_id).to eq('batchID_2008-06-23')
      expect(bag.works.first).to be_a(Import::Work)
    end
  end

  describe 'an invalid bag' do
    subject(:bag) { described_class.new(invalid_path) }

    let(:invalid_path) { ImportFactory::Bag.root.join('invalid') }

    before { FileUtils.mkdir_p(invalid_path) }

    it do
      expect(bag).not_to be_valid
      expect(bag.errors.messages).to include(bag: ['there are no manifest files', 'is invalid'])
    end
  end

  describe 'a bag with a missing a date' do
    subject(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batchNoDate',
        data: {
          workID: [
            'workID_preservation.tif',
            'workID_text.txt',
            'workID_thumb.jpg'
          ]
        }
      )
    end

    it do
      expect(bag).to be_valid
      expect(bag.date).to be_nil
      expect(bag.batch_id).to eq('batchNoDate')
    end
  end

  describe 'a bag with an invalid date' do
    subject(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batchBadDate_06-12',
        data: {
          workID: [
            'workID_preservation.tif',
            'workID_text.txt',
            'workID_thumb.jpg'
          ]
        }
      )
    end

    it do
      expect(bag).to be_valid
      expect(bag.date).to be_nil
      expect(bag.batch_id).to eq('batchBadDate_06-12')
    end
  end

  describe 'a bag with extraneous files' do
    subject(:bag) { described_class.new(path) }

    let(:path) { Rails.root.join('spec', 'fixtures', 'bags', 'extraFiles_2008-06-23') }

    it do
      expect(bag).not_to be_valid
      expect(bag.errors.messages[:bag]).to include(
        'workID_service.jp2 cannot be under data',
        'workID_text.txt cannot be under data',
        'workID_thumb.jpg cannot be under data'
      )
    end
  end

  describe 'a bag with a bad checksum' do
    subject(:bag) { described_class.new(path) }

    let(:path) { Rails.root.join('spec', 'fixtures', 'bags', 'badChecksum_2008-06-23') }

    it do
      expect(bag).not_to be_valid
      expect(bag.errors.messages).to include(bag:
        ["expected #{path}/data/workID/workID_preservation.tif to have Digest::SHA256: " \
         '0000000000000000000000000000000000000000000000000000000000000000, actual is ' \
         '3d9f6b983f4ba463f7dae1e578d6ebf1c9236fd4f55e5156a7b094e497d5f927', 'is invalid'])
    end
  end

  describe 'a bag with invalid works' do
    subject(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batchID_2008-07-12',
        data: {
          workID: [
            'badID_01_preservation.tif',
            'workID_01_service.jp2',
            'workID_01_text.txt',
            'workID_01_thumb.jpg'
          ]
        }
      )
    end

    it do
      expect(bag).not_to be_valid
      expect(bag.errors.messages)
        .to include(works: ['Import file badID_01_preservation.tif does not match the parent directory'])
    end
  end

  describe 'a bag with a non-existent path' do
    let(:path) { Rails.root.join('spec', 'fixtures', 'bags', 'non-existent-bag') }

    it 'raises an error' do
      expect { described_class.new(path) }.to raise_error(IOError, 'path to bag does not exist or is not readable')
    end
  end

  describe 'a user-submitted example' do
    subject(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'pst_1028552845_2019-02-21',
        data: {
          pst_1028552845: [
            'pst_1028552845_00001_preservation.tif',
            'pst_1028552845_00001_service.jp2',
            'pst_1028552845_00001_text.txt',
            'pst_1028552845_00001_thumb.jpg',
            'pst_1028552845_00002_preservation.tif',
            'pst_1028552845_00002_service.jp2',
            'pst_1028552845_00002_text.txt',
            'pst_1028552845_00002_thumb.jpg',
            'pst_1028552845_00003_preservation.tif',
            'pst_1028552845_00003_service.jp2',
            'pst_1028552845_00003_text.txt',
            'pst_1028552845_00003_thumb.jpg',
            'pst_1028552845_access.pdf',
            'pst_1028552845_text.txt',
            'pst_1028552845_thumb.jpg'
          ]
        }
      )
    end

    it do
      expect(bag).to be_valid
      expect(bag.errors).to be_empty
      expect(bag.date).to eq('2019-02-21')
      expect(bag.batch_id).to eq('pst_1028552845_2019-02-21')
      expect(bag.works.first).to be_a(Import::Work)
    end
  end

  describe 'works with varied file set ids' do
    let(:batch_a) do
      ImportFactory::Bag.create(
        batch_id: 'batch_a',
        data: {
          workID: [
            'workID_00001_01_preservation.tif',
            'workID_00001_01_preservation-redacted.tif',
            'workID_00001_01_service.jp2',
            'workID_00001_01_text.txt',
            'workID_00001_01_thumb.jpg',
            'workID_00001_02_preservation.tif',
            'workID_00001_02_service.jp2',
            'workID_00001_02_text.txt',
            'workID_00001_02_thumb.jpg',
            'workID_00002_01_preservation.tif',
            'workID_00002_01_service.jp2',
            'workID_00002_01_text.txt',
            'workID_00002_01_thumb.jpg',
            'workID_00002_02_preservation.tif',
            'workID_00002_02_service.jp2',
            'workID_00002_02_text.txt',
            'workID_00002_02_thumb.jpg'
          ]
        }
      )
    end

    let(:batch_b) do
      ImportFactory::Bag.create(
        batch_id: 'batch_b',
        data: {
          workID: [
            'workID_00001_preservation.tif',
            'workID_00001_preservation-redacted.tif',
            'workID_00001_service.jp2',
            'workID_00001_text.txt',
            'workID_00001_thumb.jpg',
            'workID_00002_preservation.tif',
            'workID_00002_service.jp2',
            'workID_00002_text.txt',
            'workID_00002_thumb.jpg',
            'workID_00003_preservation.tif',
            'workID_00003_service.jp2',
            'workID_00003_text.txt',
            'workID_00003_thumb.jpg',
            'workID_00004_preservation.tif',
            'workID_00004_service.jp2',
            'workID_00004_text.txt',
            'workID_00004_thumb.jpg'
          ]
        }
      )
    end

    let(:batch_c) do
      ImportFactory::Bag.create(
        batch_id: 'batch_c',
        data: {
          workID: [
            'workID_00001_01_preservation.tif',
            'workID_00001_01_preservation-redacted.tif',
            'workID_00001_01_service.jp2',
            'workID_00001_01_text.txt',
            'workID_00001_01_thumb.jpg',
            'workID_00001_02_preservation.tif',
            'workID_00001_02_service.jp2',
            'workID_00001_02_text.txt',
            'workID_00001_02_thumb.jpg',
            'workID_00003_preservation.tif',
            'workID_00003_service.jp2',
            'workID_00003_text.txt',
            'workID_00003_thumb.jpg',
            'workID_00004_preservation.tif',
            'workID_00004_service.jp2',
            'workID_00004_text.txt',
            'workID_00004_thumb.jpg'
          ]
        }
      )
    end

    it do
      expect(batch_a).to be_valid
      expect(batch_b).to be_valid
      expect(batch_c).to be_valid
      expect(batch_a.works.first.file_sets.map(&:id).sort).to eq(
        ['workID_00001_01', 'workID_00001_02', 'workID_00002_01', 'workID_00002_02']
      )
      expect(batch_b.works.first.file_sets.map(&:id).sort).to eq(
        ['workID_00001', 'workID_00002', 'workID_00003', 'workID_00004']
      )
      expect(batch_c.works.first.file_sets.map(&:id).sort).to eq(
        ['workID_00001_01', 'workID_00001_02', 'workID_00003', 'workID_00004']
      )
    end
  end
end
