# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataApplicationProfileField, type: :model do
  subject { model }

  let(:model) { MetadataApplicationProfileField.new }

  it { is_expected.to respond_to(:label) }
  it { is_expected.to respond_to(:multiple) }
  it { is_expected.to respond_to(:field_type) }
  it { is_expected.to respond_to(:requirement_designation) }
  it { is_expected.to respond_to(:controlled_vocabulary) }
  it { is_expected.to respond_to(:default_value) }
  it { is_expected.to respond_to(:display_name) }
  it { is_expected.to respond_to(:display_transformation) }

  it 'can be optional' do
    model.optional!
    expect(model.requirement_designation).to eq('optional')
  end

  it 'can be text' do
    model.text!
    expect(model.field_type).to eq('text')
  end

  context 'with metadata' do
    let(:expected_metadata) { { 'controlled_vocabulary' => 'abc123_vocab',
                                'created_at' => model.created_at,
                                'default_value' => 'abc123',
                                'display_name' => 'My Abc123',
                                'display_transformation' => 'abc123_transform',
                                'field_type' => 'date',
                                'id' => model.id,
                                'label' => 'abc123_label',
                                'multiple' => false,
                                'requirement_designation' => 'recommended',
                                'updated_at' => model.updated_at,
                                'validation' => 'abc123_validation' } }

    before do
      model.label = 'abc123_label'
      model.date!
      model.recommended!
      model.controlled_vocabulary = 'abc123_vocab'
      model.default_value = 'abc123'
      model.display_name = 'My Abc123'
      model.display_transformation = 'abc123_transform'
      model.multiple = false
      model.validation = 'abc123_validation'
    end

    it 'can be saved' do
      model.save
      model.reload
      expect(model.attributes).to eq(expected_metadata)
    end
  end
end
