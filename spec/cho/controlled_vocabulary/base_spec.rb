# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::Base, type: :model do
  describe '#lookup' do
    let(:error) { 'ControlledVocabulary.lookup is abstract. Children must implement.' }

    it 'raises an error' do
      expect { described_class.new.lookup('value') }.to raise_error(ControlledVocabulary::Error, error)
    end
  end
end
