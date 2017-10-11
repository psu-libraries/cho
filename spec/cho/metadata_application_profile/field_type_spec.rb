# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataApplicationProfile::WithFieldType, type: :model do
  before (:all) do
    class MyFieldModel < ApplicationRecord
      include MetadataApplicationProfile::WithFieldType
    end

    ActiveRecord::Base.connection.create_table :my_field_models do |t|
      t.string :field_type
    end
  end

  after (:all) do
    ActiveRecord::Base.connection.drop_table :my_field_models
    ActiveSupport::Dependencies.remove_constant('MyFieldModel')
  end

  subject { model.field_type }

  let(:field_type) { 'text' }
  let(:model) { MyFieldModel.new(field_type: field_type) }

  it { is_expected.to eq('text') }

  it 'is text' do
    expect(model).to be_text
  end

  it 'is not string' do
    expect(model).not_to be_string
  end

  it 'is not date' do
    expect(model).not_to be_date
  end

  it 'is not numeric' do
    expect(model).not_to be_numeric
  end

  context 'field_type is set to date' do
    before do
      model.date!
    end

    it 'is date' do
      expect(model).to be_date
    end

    it 'is not text' do
      expect(model).not_to be_text
    end

    it 'is not string' do
      expect(model).not_to be_string
    end

    it 'is not numeric' do
      expect(model).not_to be_numeric
    end
  end

  context 'field_type is set to numeric' do
    before do
      model.numeric!
    end

    it 'is numeric' do
      expect(model).to be_numeric
    end

    it 'is not date' do
      expect(model).not_to be_date
    end

    it 'is not text' do
      expect(model).not_to be_text
    end

    it 'is not string' do
      expect(model).not_to be_string
    end
  end

  context 'field_type is set to string' do
    before do
      model.string!
    end

    it 'is string' do
      expect(model).to be_string
    end

    it 'is not numeric' do
      expect(model).not_to be_numeric
    end

    it 'is not date' do
      expect(model).not_to be_date
    end

    it 'is not text' do
      expect(model).not_to be_text
    end
  end

  context 'field_type is bogus' do
    let(:field_type) { 'bogus' }

    it 'raises an error' do
      expect { model }.to raise_error(ArgumentError)
    end
  end
end
