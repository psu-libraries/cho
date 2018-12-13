# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::WithFieldType, type: :model do
  before (:all) do
    class MyFieldModel < Valkyrie::Resource
      include DataDictionary::WithFieldType
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyFieldModel')
  end

  subject(:model) { MyFieldModel.new }

  context 'field_type is set to text' do
    before { model.text! }

    it { is_expected.to be_text }
    it { is_expected.not_to be_string }
    it { is_expected.not_to be_date }
    it { is_expected.not_to be_numeric }
    it { is_expected.not_to be_valkyrie_id }
    it { is_expected.not_to be_creator }
  end

  context 'field_type is set to date' do
    before { model.date! }

    it { is_expected.not_to be_text }
    it { is_expected.not_to be_string }
    it { is_expected.to be_date }
    it { is_expected.not_to be_numeric }
    it { is_expected.not_to be_valkyrie_id }
    it { is_expected.not_to be_creator }
  end

  context 'field_type is set to numeric' do
    before { model.numeric! }

    it { is_expected.not_to be_text }
    it { is_expected.not_to be_string }
    it { is_expected.not_to be_date }
    it { is_expected.to be_numeric }
    it { is_expected.not_to be_valkyrie_id }
    it { is_expected.not_to be_creator }
  end

  context 'field_type is set to string' do
    before { model.string! }

    it { is_expected.not_to be_text }
    it { is_expected.to be_string }
    it { is_expected.not_to be_date }
    it { is_expected.not_to be_numeric }
    it { is_expected.not_to be_valkyrie_id }
    it { is_expected.not_to be_creator }
  end

  context 'field_type is set to a Valkyrie ID' do
    before { model.valkyrie_id! }

    it { is_expected.not_to be_text }
    it { is_expected.not_to be_string }
    it { is_expected.not_to be_date }
    it { is_expected.not_to be_numeric }
    it { is_expected.to be_valkyrie_id }
    it { is_expected.not_to be_creator }
  end

  context 'field_type is set to a Valkyrie ID' do
    before { model.creator! }

    it { is_expected.not_to be_text }
    it { is_expected.not_to be_string }
    it { is_expected.not_to be_date }
    it { is_expected.not_to be_numeric }
    it { is_expected.not_to be_valkyrie_id }
    it { is_expected.to be_creator }
  end

  context 'field_type is bogus' do
    it 'raises an error' do
      expect { MyFieldModel.new(field_type: 'bogus') }.to raise_error(Dry::Struct::Error)
    end
  end
end
