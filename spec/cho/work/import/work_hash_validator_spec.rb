# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::WorkHashValidator do
  let(:reader) { described_class.new(work_hash) }
  let(:collection) { create :library_collection }
  let(:generic_work_type) { Work::Type.find_using(label: 'Generic').first }

  describe '#change_set' do
    subject(:change_set) { reader.change_set }

    context 'with a new work' do
      let(:work_hash) do
        {
          'member_of_collection_ids' => [collection.id],
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
        expect(change_set.member_of_collection_ids).to eq([collection.id])
      end

      context 'with a file' do
        let(:work_hash) do
          {
            'member_of_collection_ids' => [collection.id],
            'work_type_id' => generic_work_type.id,
            'title' => 'my awesome work',
            'description' => '',
            'file_name' => 'hello_world.txt'
          }
        end

        it 'is valid and has a work type and a file set' do
          expect(change_set).to be_a(Work::SubmissionChangeSet)
          expect(change_set).to be_valid
          expect(change_set.model).to be_a(Work::Submission)
          expect(change_set.work_type_id).to eq(generic_work_type.id)
          expect(change_set.member_of_collection_ids).to eq([collection.id])
          expect(change_set.file).to be_a(ActionDispatch::Http::UploadedFile)
        end

        context 'with an absolute path configured' do
          before do
            @original_path = ENV['csv_base_path']
            ENV['csv_base_path'] = fixture_path
          end

          after do
            ENV['csv_base_path'] = @original_path
          end

          it 'is valid and has a work type and a file set' do
            expect(change_set).to be_a(Work::SubmissionChangeSet)
            expect(change_set).to be_valid
            expect(change_set.model).to be_a(Work::Submission)
            expect(change_set.work_type_id).to eq(generic_work_type.id)
            expect(change_set.member_of_collection_ids).to eq([collection.id])
            expect(change_set.file).to be_a(ActionDispatch::Http::UploadedFile)
          end
        end
      end
    end

    context 'invalid new work' do
      let(:work_hash) { { 'member_of_collection_ids' => [collection.id], 'work_type_id' => generic_work_type.id } }

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
          'member_of_collection_ids' => [collection.id],
          'title' => 'my awesome updated work',
          'description' => 'updated description'
        }
      end

      it 'is valid and has an id' do
        expect(change_set).to be_a(Work::SubmissionChangeSet)
        expect(change_set).to be_valid
        expect(change_set.model).to be_a(Work::Submission)
        expect(change_set.work_type_id).to eq(generic_work_type.id)
        expect(change_set.member_of_collection_ids).to eq([collection.id])
        expect(change_set.id).to eq(work.id)
      end
    end

    context 'with a non-existent work' do
      let(:work_hash) do
        {
          'id' => 'foo',
          'member_of_collection_ids' => [collection.id],
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
