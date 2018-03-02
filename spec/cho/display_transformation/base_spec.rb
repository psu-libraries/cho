# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisplayTransformation::Base, type: :model do
  describe '#transform' do
    let(:error) { 'DisplayTransformation.transform is abstract. Children must implement.' }

    it 'raises an error' do
      expect { described_class.new.transform('field') }.to raise_error(DisplayTransformation::Error, error)
    end
  end
end
