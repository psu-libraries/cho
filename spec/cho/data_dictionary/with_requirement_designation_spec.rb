# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::WithRequirementDesignation, type: :model do
  before do
    class MyModel < Valkyrie::Resource
      include DataDictionary::WithRequirementDesignation
    end
  end

  after do
    ActiveSupport::Dependencies.remove_constant('MyModel')
  end

  subject(:model) { MyModel.new }

  context 'requirement_desination is set to optional' do
    before { model.optional! }

    it { is_expected.not_to be_required_to_publish }
    it { is_expected.not_to be_recommended }
    it { is_expected.to be_optional }
  end

  context 'requirement_desination is set to required' do
    before { model.required_to_publish! }

    it { is_expected.to be_required_to_publish }
    it { is_expected.not_to be_recommended }
    it { is_expected.not_to be_optional }
  end

  context 'requirement_desination is set to recommended' do
    before { model.recommended! }

    it { is_expected.not_to be_required_to_publish }
    it { is_expected.to be_recommended }
    it { is_expected.not_to be_optional }
  end

  context 'requirement_designation is bogus' do
    it 'raises an error' do
      expect { MyModel.new(requirement_designation: 'bogus') }.to raise_error(Dry::Struct::Error)
    end
  end
end
