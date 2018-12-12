# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::None, type: :model do
  describe '#list' do
    subject { described_class.list }

    it { is_expected.to eq([]) }
  end
end
