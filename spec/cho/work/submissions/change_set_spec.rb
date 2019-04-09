# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::SubmissionChangeSet do
  subject(:change_set) { described_class.new(resource) }

  let(:resource) { Work::Submission.new }
  let(:work_type_id) { Work::Type.find_using(label: 'Generic').first.id }

  describe '#append_id' do
    before { change_set.append_id = Valkyrie::ID.new('test') }

    its(:append_id) { is_expected.to eq(Valkyrie::ID.new('test')) }
    its([:append_id]) { is_expected.to eq(Valkyrie::ID.new('test')) }
  end

  describe '#multiple?' do
    it 'has a singular title' do
      expect(change_set).not_to be_multiple(:title)
    end

    it 'has a single work type' do
      expect(change_set).not_to be_multiple(:work_type_id)
    end

    it 'has a single parent collection' do
      expect(change_set).not_to be_multiple(:home_collection_id)
    end

    it 'has multiple file sets' do
      expect(change_set).to be_multiple(:member_ids)
    end

    it 'has a single batch id' do
      expect(change_set).not_to be_multiple(:batch_id)
    end

    it 'has a single order index' do
      expect(change_set).not_to be_multiple(:order_index)
    end
  end

  describe '#required?' do
    it 'has a required work type' do
      expect(change_set).to be_required(:work_type_id)
    end
  end

  describe '#fields=' do
    before { change_set.prepopulate! }

    its(:title) { is_expected.to be_nil }
    its(:work_type_id) { is_expected.to eq(Valkyrie::ID.new(nil)) }
    its(:work_type) { is_expected.to be_nil }
    its(:file) { is_expected.to be_nil }
    its(:home_collection_id) { is_expected.to be_nil }
    its(:member_ids) { is_expected.to be_empty }
    its(:batch_id) { is_expected.to be_nil }
    its(:order_index) { is_expected.to eq(0) }
    its(:import_work) { is_expected.to be_nil }
    its(:file_set_hashes) { is_expected.to be_empty }
  end

  describe '#validate' do
    subject { change_set.errors }

    before { change_set.validate(params) }

    context 'without a title' do
      let(:params) { { work_type_id: work_type_id } }

      its(:full_messages) { is_expected.to include("Title can't be blank") }
    end

    context 'without a work type' do
      let(:params) { { title: 'title' } }

      its(:full_messages) { is_expected.to include("Work type can't be blank") }
    end

    context 'with a bad work type' do
      let(:params) { { title: 'title', work_type_id: 'bad one' } }

      its(:full_messages) { is_expected.to include('Work type bad one does not exist') }
    end

    context 'with non-existent parents' do
      let(:params) { { work_type_id: work_type_id, title: 'Title', home_collection_id: 'nothere' } }

      its(:full_messages) { is_expected.to include('Home collection nothere does not exist') }
    end

    context 'with existing parents and all required fields' do
      let(:collection) { create :archival_collection }
      let(:params) { { work_type_id: work_type_id, title: 'Title', home_collection_id: collection.id } }

      its(:full_messages) { is_expected.to be_empty }
    end
  end

  describe '#home_collection_id' do
    subject(:ids) { change_set.home_collection_id }

    context 'with an id' do
      before { change_set.validate(home_collection_id: '1') }

      it { is_expected.to be_kind_of(Valkyrie::ID) }
    end

    context 'with a null id' do
      before { change_set.validate(home_collection_id: nil) }

      it { is_expected.to be_nil }
    end

    context 'with an empty id' do
      before { change_set.validate(home_collection_id: '') }

      it 'does not cast empty strings to ids' do
        pending('.optional should not cast ids for empty strings' \
                'See https://github.com/samvera-labs/valkyrie/issues/605')
        expect(ids).to be_nil
      end
    end
  end

  describe '#member_ids' do
    before { change_set.validate(member_ids: ['1']) }

    it 'casts ids to Valkyrie IDs' do
      expect(change_set.member_ids.first).to be_kind_of(Valkyrie::ID)
    end
  end

  describe '#submit_text' do
    its(:submit_text) { is_expected.to eq('Create Resource') }

    context 'save work' do
      let(:unsaved_work) { Work::Submission.new }
      let(:resource) { Valkyrie.config.metadata_adapter.persister.save(resource: unsaved_work) }

      its(:submit_text) { is_expected.to eq('Update Resource') }
    end
  end

  describe '#form_path' do
    its(:form_path) { is_expected.to eq('/works') }

    context 'save work' do
      let(:unsaved_work) { Work::Submission.new }
      let(:resource) { Valkyrie.config.metadata_adapter.persister.save(resource: unsaved_work) }

      its(:form_path) { is_expected.to eq("/works/#{resource.id}") }
    end
  end

  context 'with a defined work type' do
    let(:resource) { Work::Submission.new(work_type_id: work_type.id) }
    let(:work_type) { Work::Type.find_using(label: 'Generic').first }

    describe '#model' do
      its(:model) { is_expected.to eq(resource) }
      its(:work_type) { is_expected.to eq(work_type) }
      its(:work_type_id) { is_expected.to eq(work_type.id) }
    end

    describe '#fields' do
      subject(:fields) { change_set.form_fields }

      let(:work_field) { Schema::MetadataField.find_using(label: 'generic_field').first }

      it 'is ordered' do
        expect(fields.map(&:label)).to eq(
          [
            'title',
            'subtitle',
            'description',
            'alternate_ids',
            'creator',
            'generic_field',
            'home_collection_id',
            'created'
          ]
        )
      end

      context 'fields are reordered' do
        before do
          work_field.order_index = -1
          Valkyrie.config.metadata_adapter.persister.save(resource: work_field)
        end

        it 'is ordered' do
          expect(fields.map(&:label)).to eq(
            [
              'generic_field',
              'title',
              'subtitle',
              'description',
              'alternate_ids',
              'creator',
              'home_collection_id',
              'created'
            ]
          )
        end
      end
    end

    describe '#input_fields' do
      let(:form) { double }

      it 'contains an array of Schema::InputFields' do
        expect(change_set.input_fields(form).map(&:label)).to contain_exactly('subtitle',
                                                                              'description',
                                                                              'generic_field',
                                                                              'alternate_ids',
                                                                              'home_collection_id',
                                                                              'created',
                                                                              'title',
                                                                              'creator')
      end
    end
  end

  context 'with no work type' do
    let(:resource) { Work::Submission.new(work_type_id: nil) }

    its(:work_type) { is_expected.to be_nil }
  end
end
