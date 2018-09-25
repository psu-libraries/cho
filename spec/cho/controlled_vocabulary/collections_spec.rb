# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::Collections, type: :model do
  describe '::list' do
    subject { described_class.list }

    context 'with no collections' do
      it { is_expected.to be_empty }
    end

    context 'with example collections present' do
      let!(:archival_collection) { create(:archival_collection) }
      let!(:library_collection)  { create(:library_collection)  }
      let!(:curated_collection)  { create(:curated_collection) }

      it { is_expected.to contain_exactly(kind_of(Collection::Archival), kind_of(Collection::Library)) }
    end
  end
end
