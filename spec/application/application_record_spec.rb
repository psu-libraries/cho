# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  before(:all) do
    class SampleRecord < ApplicationRecord
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('SampleRecord')
  end

  context 'when used alone' do
    it 'raises an error' do
      expect {
        described_class.new
      }.to raise_error(NotImplementedError, 'ApplicationRecord is an abstract class and cannot be instantiated.')
    end
  end

  context 'when it is extended with a custom class' do
    subject { SampleRecord }

    its(:ancestors) { is_expected.to include(described_class) }
  end
end
