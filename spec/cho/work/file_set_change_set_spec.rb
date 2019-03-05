# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::FileSetChangeSet do
  subject(:change_set) { described_class.new(resource) }

  let(:resource) { Work::FileSet.new }

  describe '#append_id' do
    before { change_set.append_id = Valkyrie::ID.new('test') }

    its(:append_id) { is_expected.to eq(Valkyrie::ID.new('test')) }
    its([:append_id]) { is_expected.to eq(Valkyrie::ID.new('test')) }
  end

  describe '#fields=' do
    before { change_set.prepopulate! }

    its(:title) { is_expected.to be_empty }
    its(:member_ids) { is_expected.to be_empty }
  end

  describe '#validate' do
    subject { change_set.errors }

    before { change_set.validate(params) }

    context 'without a title' do
      let(:params) { {} }

      its(:full_messages) { is_expected.to include("Title can't be blank") }
    end

    context 'with non-existent parents' do
      let(:params) { { member_ids: ['nothere'] } }

      its(:full_messages) { is_expected.to include('Member ids nothere does not exist') }
    end

    context 'with all required fields' do
      let(:file) { create :work_file }
      let(:params) { { title: 'filename.txt', member_ids: [file.id] } }

      its(:full_messages) { is_expected.to be_empty }
    end
  end

  describe '#member_ids' do
    before { change_set.validate(member_ids: ['1']) }

    it 'casts ids to Valkyrie IDs' do
      expect(change_set.member_ids.first).to be_kind_of(Valkyrie::ID)
    end
  end

  describe '#form_fields' do
    let(:metadata_schema) { Schema::Metadata.find_using(label: 'FileSet').first }

    it 'returns a list of fields from the FileSet metadata schema' do
      expect(change_set.form_fields.map(&:id)).to eq(metadata_schema.core_fields)
    end
  end

  describe '#input_fields' do
    let(:form) { double }

    it 'contains an array of Schema::InputFields' do
      expect(change_set.input_fields(form).map(&:label)).to contain_exactly(
        'subtitle',
                                                                'description',
                                                                'title',
                                                                'alternate_ids',
                                                                'creator'
      )
    end
  end
end
