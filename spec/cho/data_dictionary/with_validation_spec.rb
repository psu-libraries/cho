# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::WithValidation, type: :model do
  before do
    class MyModel < Valkyrie::Resource
      include DataDictionary::WithValidation
    end
  end

  after do
    ActiveSupport::Dependencies.remove_constant('MyModel')
  end

  subject { model.validation }

  let(:validation) { 'no_validation' }
  let(:model) { MyModel.new(validation: validation) }

  it { is_expected.to eq(validation) }

  context 'validation is bogus' do
    let(:validation) { 'bogus' }

    it 'raises an error' do
      expect { model }.to raise_error(Dry::Struct::Error)
    end
  end
end
