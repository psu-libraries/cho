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

  describe '#required?' do
    it 'has a required title' do
      expect(change_set).to be_required(:title)
    end
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

    context 'without members' do
      let(:params) { { member_ids: [] } }

      its(:full_messages) { is_expected.to include("Member ids can't be blank") }
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
end
