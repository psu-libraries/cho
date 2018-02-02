# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::SubmissionChangeSet do
  subject(:change_set) { described_class.new(resource) }

  let(:resource) { Work::Submission.new }

  describe '#append_id' do
    before { change_set.append_id = Valkyrie::ID.new('test') }
    its(:append_id) { is_expected.to eq(Valkyrie::ID.new('test')) }
    its([:append_id]) { is_expected.to eq(Valkyrie::ID.new('test')) }
  end

  describe '#multiple?' do
    it 'has multiple titles' do
      expect(change_set).to be_multiple(:title)
    end

    it 'has a single work type' do
      expect(change_set).not_to be_multiple(:work_type)
    end
  end

  describe '#required?' do
    it 'has a required title' do
      expect(change_set).to be_required(:title)
    end

    it 'has a required work type' do
      expect(change_set).to be_required(:work_type)
    end
  end

  describe '#fields=' do
    before { change_set.prepopulate! }
    its(:title) { is_expected.to be_empty }
    its(:work_type) { is_expected.to be_nil }
  end

  describe '#validate' do
    subject { change_set.errors }

    before { change_set.validate(params) }

    context 'without a title' do
      let(:params) { { work_type: 'work type' } }

      its(:full_messages) { is_expected.to include("Title can't be blank") }
    end

    context 'without a work type' do
      let(:params) { { title: 'title' } }

      its(:full_messages) { is_expected.to include("Work type can't be blank") }
    end

    context 'with all required fields' do
      let(:params) { { work_type: 'work type', title: 'Title' } }

      its(:full_messages) { is_expected.to be_empty }
    end
  end
end
