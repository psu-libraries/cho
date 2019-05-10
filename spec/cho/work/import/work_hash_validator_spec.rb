# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::WorkHashValidator do
  let(:reader) do
    described_class.new(work_hash,
                        resource_class: Work::Submission,
                        change_set_class: Work::SubmissionChangeSet)
  end

  let(:collection) { create :library_collection }
  let(:generic_work_type) { Work::Type.find_using(label: 'Generic').first }
  let(:still_image_work_type) { Work::Type.find_using(label: 'Still Image').first }

  describe '#change_set' do
    subject(:change_set) { reader.change_set }

    context 'with a new work' do
      let(:work_hash) do
        {
          'home_collection_id' => [collection.id],
          'work_type_id' => generic_work_type.id,
          'title' => 'my awesome work',
          'description' => ''
        }
      end

      it 'is valid and has a work type set' do
        expect(change_set).to be_a(Work::SubmissionChangeSet)
        expect(change_set).to be_valid
        expect(change_set.model).to be_a(Work::Submission)
        expect(change_set.work_type_id).to eq(generic_work_type.id)
        expect(change_set.home_collection_id).to eq(collection.id)
      end

      context 'with a work type properly cased' do
        let(:work_hash) do
          {
            'home_collection_id' => [collection.id],
            'work_type' => 'Still Image',
            'title' => 'my awesome work',
            'description' => ''
          }
        end

        it 'is valid and has a work type set' do
          expect(change_set).to be_a(Work::SubmissionChangeSet)
          expect(change_set).to be_valid
          expect(change_set.model).to be_a(Work::Submission)
          expect(change_set.work_type_id).to eq(still_image_work_type.id)
          expect(change_set.home_collection_id).to eq(collection.id)
        end
      end

      context 'with a work type improperly upper cased' do
        let(:work_hash) do
          {
            'home_collection_id' => [collection.id],
            'work_type' => 'GENERIC',
            'title' => 'my awesome work',
            'description' => ''
          }
        end

        it 'is valid and has a work type set' do
          expect(change_set).to be_a(Work::SubmissionChangeSet)
          expect(change_set).to be_valid
          expect(change_set.model).to be_a(Work::Submission)
          expect(change_set.work_type_id).to eq(generic_work_type.id)
          expect(change_set.home_collection_id).to eq(collection.id)
        end
      end

      context 'with a work type improperly lower cased' do
        let(:work_hash) do
          {
            'home_collection_id' => [collection.id],
            'work_type' => 'geNeric',
            'title' => 'my awesome work',
            'description' => ''
          }
        end

        it 'is valid and has a work type set' do
          expect(change_set).to be_a(Work::SubmissionChangeSet)
          expect(change_set).to be_valid
          expect(change_set.model).to be_a(Work::Submission)
          expect(change_set.work_type_id).to eq(generic_work_type.id)
          expect(change_set.home_collection_id).to eq(collection.id)
        end
      end
    end

    context 'invalid new work' do
      let(:work_hash) { { 'home_collection_id' => [collection.id], 'work_type_id' => generic_work_type.id } }

      it 'is not valid and has errors' do
        expect(change_set).not_to be_valid
        expect(change_set.errors.full_messages).to eq(["Title can't be blank"])
      end
    end

    context 'with an existing work' do
      let(:work) { create(:work) }

      let(:work_hash) do
        {
          'id' => work.id,
          'home_collection_id' => [collection.id],
          'title' => 'my awesome updated work',
          'description' => 'updated description'
        }
      end

      it 'is valid and has an id' do
        expect(change_set).to be_a(Work::SubmissionChangeSet)
        expect(change_set).to be_valid
        expect(change_set.model).to be_a(Work::Submission)
        expect(change_set.work_type_id).to eq(generic_work_type.id)
        expect(change_set.home_collection_id).to eq(collection.id)
        expect(change_set.id).to eq(work.id)
      end

      context 'with a changed work_type' do
        let(:work_hash) do
          {
            'id' => work.id,
            'home_collection_id' => [collection.id],
            'title' => 'my awesome updated work',
            'description' => 'updated description',
            'work_type' => 'Audio'
          }
        end

        it 'is not valid and has an id' do
          expect(change_set).to be_a(Work::SubmissionChangeSet)
          expect(change_set).not_to be_valid
          expect(change_set.errors.full_messages).to eq(['Work type can not be changed'])
        end
      end
    end

    context 'with a non-existent work' do
      let(:work_hash) do
        {
          'id' => 'foo',
          'home_collection_id' => [collection.id],
          'title' => 'my awesome updated work',
          'description' => 'updated description'
        }
      end

      it 'is not valid and has errors' do
        expect(change_set).not_to be_valid
        expect(change_set.errors.full_messages).to eq(['Id does not exist'])
      end
    end
  end
end
