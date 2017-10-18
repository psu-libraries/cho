# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisplayTransformation::None, type: :model do
  subject { described_class.new }

  it { within_block_is_expected.not_to raise_exception(DisplayTransformation::Error) }

  describe '#transform' do
    subject { described_class.new.transform('abc') }

    it { is_expected.to eq('abc') }
  end
end
