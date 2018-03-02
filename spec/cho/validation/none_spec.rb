# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::None, type: :model do
  describe '#validate' do
    subject { described_class.new.validate('field') }

    it { is_expected.to be_truthy }
  end
end
