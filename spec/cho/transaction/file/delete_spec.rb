# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::File::Delete do
  let(:transaction) { described_class.new }

  describe '::steps' do
    subject { described_class.steps.map(&:name) }

    it { is_expected.to contain_exactly(:delete) }
  end

  it { is_expected.to respond_to(:call) }
end
