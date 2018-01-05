# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionChangeSet do
  subject(:change_set) { described_class.new(resource) }

  let(:resource) { Collection.new }

  describe '#append_id' do
    before { change_set.append_id = Valkyrie::ID.new('test') }
    its(:append_id) { is_expected.to eq(Valkyrie::ID.new('test')) }
    its([:append_id]) { is_expected.to eq(Valkyrie::ID.new('test')) }
  end

  describe '#multiple?' do
    it 'has single fields' do
      expect(change_set).not_to be_multiple(:title)
      expect(change_set).not_to be_multiple(:description)
    end
  end

  describe '#required?' do
    it 'has a required title and type' do
      expect(change_set).to be_required(:title)
      expect(change_set).to be_required(:collection_type)
    end
  end

  describe '#fields=' do
    before { change_set.prepopulate! }
    its(:title) { is_expected.to be_nil }
    its(:collection_type) { is_expected.to be_nil }
  end

  describe '#validate' do
    subject { change_set.errors }

    before { change_set.validate(params) }

    context 'without a title' do
      let(:params) { { collection_type: 'archival' } }

      its(:full_messages) { is_expected.to include("Title can't be blank") }
    end

    context 'without a work type' do
      let(:params) { { title: 'title' } }

      its(:full_messages) { is_expected.to include("Collection type can't be blank") }
    end

    context 'with an unsupported collection type' do
      let(:params) { { title: 'title', collection_type: 'foo' } }

      its(:full_messages) { is_expected.to include('Collection type is not included in the list') }
    end

    context 'with all required fields' do
      let(:params) { { collection_type: 'archival', title: 'Title' } }

      its(:full_messages) { is_expected.to be_empty }
    end
  end
end
