# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::WithUseType, type: :model do
  subject(:model) { MyFileModel.new }

  before (:all) do
    class MyFileModel < Valkyrie::Resource
      include Work::WithUseType
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyFileModel')
  end

  context 'with a preservation type' do
    before { model.preservation! }

    it do
      expect(model).not_to be_text
      expect(model).not_to be_access
      expect(model).to be_preservation
      expect(model).not_to be_preservation_redacted
      expect(model).not_to be_service
      expect(model).not_to be_thumb
    end
  end

  context 'with a redacted preservation type' do
    before { model.preservation_redacted! }

    it do
      expect(model).not_to be_text
      expect(model).not_to be_access
      expect(model).not_to be_preservation
      expect(model).to be_preservation_redacted
      expect(model).not_to be_service
      expect(model).not_to be_thumb
    end
  end

  context 'with a text type' do
    before { model.text! }

    it do
      expect(model).to be_text
      expect(model).not_to be_access
      expect(model).not_to be_preservation
      expect(model).not_to be_preservation_redacted
      expect(model).not_to be_service
      expect(model).not_to be_thumb
    end
  end

  context 'with a access type' do
    before { model.access! }

    it do
      expect(model).not_to be_text
      expect(model).to be_access
      expect(model).not_to be_preservation
      expect(model).not_to be_preservation_redacted
      expect(model).not_to be_service
      expect(model).not_to be_thumb
    end
  end

  context 'with a service type' do
    before { model.service! }

    it do
      expect(model).not_to be_text
      expect(model).not_to be_access
      expect(model).not_to be_preservation
      expect(model).not_to be_preservation_redacted
      expect(model).to be_service
      expect(model).not_to be_thumb
    end
  end

  context 'with a thumbnail type' do
    before { model.thumb! }

    it do
      expect(model).not_to be_text
      expect(model).not_to be_access
      expect(model).not_to be_preservation
      expect(model).not_to be_preservation_redacted
      expect(model).not_to be_service
      expect(model).to be_thumb
    end
  end

  context 'field_type is bogus' do
    let(:model) { MyFileModel.new(use: 'bogus') }

    it 'raises an error' do
      expect { model }.to raise_error(Dry::Struct::Error)
    end
  end
end
