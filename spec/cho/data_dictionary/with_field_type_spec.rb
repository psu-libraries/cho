# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::WithFieldType, type: :model do
  subject(:model) { MyFieldModel.new }

  before (:all) do
    class MyFieldModel < Valkyrie::Resource
      include DataDictionary::WithFieldType
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyFieldModel')
  end

  describe '::TYPES' do
    specify do
      expect(DataDictionary::WithFieldType::TYPES).to contain_exactly(
        'string',
        'text',
        'numeric',
        'date',
        'valkyrie_id',
        'alternate_id',
        'creator',
        'radio_button'
      )
    end
  end

  describe 'setting a field type' do
    specify do
      expect(model.text?).to be(false)
      model.text!
      expect(model.text?).to be(true)
    end
  end

  describe 'setting a field to a bogus type' do
    it 'raises an error' do
      expect { MyFieldModel.new(field_type: 'bogus') }.to raise_error(Dry::Struct::Error)
    end
  end
end
