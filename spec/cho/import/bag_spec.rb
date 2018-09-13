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
      is_expected.to be_valid
      expect(bag.errors).to be_empty
      expect(bag.date).to eq('2008-06-23')
      expect(bag.batch_id).to eq('batchID')
      expect(bag.works.first).to be_a(Import::Work)
    end
  end

  describe 'an invalid bag' do
    subject(:bag) { described_class.new(Rails.root.join('tmp')) }

    it do
      expect(bag).not_to be_valid
      expect(bag.errors.messages).to include(bag: ['there are no manifest files', 'is invalid'])
    end
  end

  describe 'a bag with a missing a date' do
    subject(:bag) { ImportFactory::Bag.create(batch_id: 'batchNoDate', data: {}) }

    it do
      expect(bag).not_to be_valid
      expect(bag.errors.messages).to include(date: ['cannot be blank'])
    end
  end

  describe 'a bag with an invalid date' do
    subject(:bag) { ImportFactory::Bag.create(batch_id: 'batchBadDate_06-12', data: {}) }

    it do
      expect(bag).not_to be_valid
      expect(bag.errors.messages).to include(date: ['06-12 is not in YYYY-MM-DD format'])
    end
  end

  describe 'a bag with extraneous files' do
    subject(:bag) { described_class.new(path) }

    let(:path) { Rails.root.join('spec', 'fixtures', 'bags', 'extraFiles_2008-06-23') }

    it do
      is_expected.not_to be_valid
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
      is_expected.not_to be_valid
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
end
