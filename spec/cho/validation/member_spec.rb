# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::Member, type: :model do
  describe '#exists?' do
    context 'with an id' do
      subject { described_class.new(collection.id.to_s) }

      let(:collection) { create(:archival_collection) }

      its(:exists?) { is_expected.to be(true) }
    end

    context 'with a non-existent id' do
      subject { described_class.new('non-existent-id') }

      its(:exists?) { is_expected.to be(false) }
    end
  end
end
