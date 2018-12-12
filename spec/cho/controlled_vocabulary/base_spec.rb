# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::Base, type: :model do
  describe '#list' do
    let(:error) { 'ControlledVocabulary.list is abstract. Children must implement.' }

    it 'raises an error' do
      expect { described_class.list }.to raise_error(ControlledVocabulary::Error, error)
    end
  end
end
