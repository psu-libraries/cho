# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Csv::Importer do
  let(:collection) { create :library_collection }
  let(:work_type_id) { Work::Type.find_using(label: 'Generic').first.id }

  let(:work_hash_1) do
    { member_of_collection_ids: [collection.id], work_type_id: [work_type_id], title: 'My first work' }
  end

  let(:work_hash_2) do
    { member_of_collection_ids: [collection.id], work_type_id: [work_type_id], title: 'My second work' }
  end

  let(:change_set_list) { [Work::SubmissionChangeSet.new(Work::Submission.new(work_hash_1)),
                           Work::SubmissionChangeSet.new(Work::Submission.new(work_hash_2))] }

  let(:importer) { described_class.new(change_set_list) }

  it 'creates the works' do
    status = false
    expect { status = importer.run }.to change(Work::Submission, :count).by(2)
    expect(status).to be_truthy
  end

  context 'invalid work hash' do
    let(:work_hash_2) { { member_of_collection_ids: [collection.id], work_type_id: [work_type_id], title: nil } }

    it 'does not create the works' do
      status = false
      expect { status = importer.run }.to change(Work::Submission, :count).by(0)
      expect(status).to be_falsey
      expect(importer.errors).to eq(['Invalid items in list'])
    end
  end

  context 'error during save' do
    let(:bad_persister) { ChangeSetPersister.new(metadata_adapter: nil, storage_adapter: nil) }
    let(:importer) { described_class.new(change_set_list, bad_persister) }

    it 'does not create the works' do
      status = false
      expect { status = importer.run }.to change(Work::Submission, :count).by(0)
      expect(status).to be_falsey
      expect(importer.errors.count).to eq(2)
      expect(importer.errors.map(&:class)).to eq([Work::SubmissionChangeSet, Work::SubmissionChangeSet])
      expect(importer.errors.map(&:errors).map(&:full_messages)).to eq(
        [
          ['Save ChangeSetPersister#persister delegated to metadata_adapter.persister, '\
           "but metadata_adapter is nil: #{bad_persister.inspect}"],
          ['Save ChangeSetPersister#persister delegated to metadata_adapter.persister, '\
           "but metadata_adapter is nil: #{bad_persister.inspect}"]
        ]
      )
    end
  end

  context 'with a file' do
    let(:file_name) { Rails.root.join('spec', 'fixtures', 'hello_world.txt') }

    let(:work_hash_1) do
      {
        member_of_collection_ids: [collection.id],
        work_type_id: [work_type_id],
        title: 'My first work',
        file_name: file_name
      }
    end

    let(:change_set_list) { [Work::SubmissionChangeSet.new(Work::Submission.new(work_hash_1))] }

    it 'creates the works' do
      status = false
      expect { status = importer.run }.to change(Work::Submission, :count).by(1)
      expect(status).to be_truthy
    end
  end
end
