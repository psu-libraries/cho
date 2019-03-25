# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::Member, type: :model do
  describe '#exists_by_id?' do
    context 'with an id' do
      subject { described_class.new(collection.id.to_s) }

      let(:collection) { create(:archival_collection) }

      its(:exists_by_id?) { is_expected.to be(true) }
    end

    context 'with a non-existent id' do
      subject { described_class.new('non-existent-id') }

      its(:exists_by_id?) { is_expected.to be(false) }
    end
  end

  describe '#exists?' do
    let(:instance) { described_class.new('id') }

    it 'is aliased to #exists_by_id?' do
      expect(instance.method(:exists?) == instance.method(:exists_by_id?)).to be(true)
    end
  end

  describe '#exists_by_alternate_id?' do
    context 'with an id' do
      subject { described_class.new(collection.alternate_ids.first) }

      let(:collection) { create(:archival_collection, alternate_ids: 'alt-id') }

      its(:exists_by_alternate_id?) { is_expected.to be(true) }
    end

    context 'with a non-existent id' do
      subject { described_class.new('non-existent-id') }

      its(:exists_by_alternate_id?) { is_expected.to be(false) }
    end
  end
end
