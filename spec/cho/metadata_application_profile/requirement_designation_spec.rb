# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataApplicationProfile::WithRequirementDesignation, type: :model do
  before do
    class MyModel < ApplicationRecord
      include MetadataApplicationProfile::WithRequirementDesignation
    end

    ActiveRecord::Base.connection.create_table :my_models do |t|
      t.string :requirement_designation
    end
  end

  after do
    ActiveRecord::Base.connection.drop_table :my_models
    ActiveSupport::Dependencies.remove_constant('MyModel')
  end

  subject { model.requirement_designation }

  let(:requirement_designation) { 'optional' }
  let(:model) { MyModel.new(requirement_designation: requirement_designation) }

  it { is_expected.to eq('optional') }

  it 'is optional' do
    expect(model).to be_optional
  end

  it 'is not required to publish' do
    expect(model).not_to be_required_to_publish
  end

  it 'is not recommended' do
    expect(model).not_to be_recommended
  end

  context 'requirement_desination is set to required' do
    before do
      model.required_to_publish!
    end

    it 'is required to publish' do
      expect(model).to be_required_to_publish
    end

    it 'is not recommended' do
      expect(model).not_to be_recommended
    end

    it 'is not optional' do
      expect(model).not_to be_optional
    end
  end

  context 'requirement_desination is set to recommended' do
    before do
      model.recommended!
    end

    it 'is recommended' do
      expect(model).to be_recommended
    end

    it 'is not optional' do
      expect(model).not_to be_optional
    end

    it 'is not required to publish' do
      expect(model).not_to be_required_to_publish
    end
  end

  context 'requirement_designation is bogus' do
    let(:requirement_designation) { 'bogus' }

    it 'raises an error' do
      expect { model }.to raise_error(ArgumentError)
    end
  end
end
