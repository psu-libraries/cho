# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::None, type: :model do
  subject { described_class.new }

  it { within_block_is_expected.not_to raise_exception }

  describe '#transform' do
    subject { described_class.new.lookup('abc') }

    it { is_expected.to eq([]) }
  end
end
