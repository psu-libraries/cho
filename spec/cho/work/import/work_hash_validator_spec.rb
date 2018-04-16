# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::WorkHashValidator do
  let(:reader) { described_class.new(work_hash) }
  let(:collection) { create :library_collection }
  let(:work_hash) { { 'member_of_collection_ids' => [collection.id], 'work_type_id' => generic_work_type.id, 'title' => 'my awesome work', 'description' => '' } }
  let(:generic_work_type) { Work::Type.find_using(label: 'Generic').first }

  describe '#change_set' do
    subject(:change_set) { reader.change_set }

    it 'is valid and has a work type set' do
      expect(change_set).to be_a(Work::SubmissionChangeSet)
      expect(change_set).to be_valid
      expect(change_set.model).to be_a(Work::Submission)
      expect(change_set.work_type_id).to eq(generic_work_type.id)
      expect(change_set.member_of_collection_ids).to eq([collection.id])
    end

    context 'invalid work' do
      let(:work_hash) { { 'member_of_collection_ids' => [collection.id], 'work_type_id' => generic_work_type.id } }

      it 'is not valid and has errors' do
        expect(change_set).not_to be_valid
        expect(change_set.errors.full_messages).to eq(["Title can't be blank"])
      end
    end
  end
end
