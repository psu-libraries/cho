# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::WithUseType, type: :model do
  before (:all) do
    class MyFileModel < Valkyrie::Resource
      include Work::WithUseType
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyFileModel')
  end

  subject(:model) { MyFileModel.new }

  context 'with a preservation type' do
    before { model.preservation! }

    it do
      is_expected.not_to be_text
      is_expected.not_to be_access
      is_expected.to be_preservation
      is_expected.not_to be_preservation_redacted
      is_expected.not_to be_service
      is_expected.not_to be_thumbnail
    end
  end

  context 'with a redacted preservation type' do
    before { model.preservation_redacted! }

    it do
      is_expected.not_to be_text
      is_expected.not_to be_access
      is_expected.not_to be_preservation
      is_expected.to be_preservation_redacted
      is_expected.not_to be_service
      is_expected.not_to be_thumbnail
    end
  end

  context 'with a text type' do
    before { model.text! }

    it do
      is_expected.to be_text
      is_expected.not_to be_access
      is_expected.not_to be_preservation
      is_expected.not_to be_preservation_redacted
      is_expected.not_to be_service
      is_expected.not_to be_thumbnail
    end
  end

  context 'with a access type' do
    before { model.access! }

    it do
      is_expected.not_to be_text
      is_expected.to be_access
      is_expected.not_to be_preservation
      is_expected.not_to be_preservation_redacted
      is_expected.not_to be_service
      is_expected.not_to be_thumbnail
    end
  end

  context 'with a service type' do
    before { model.service! }

    it do
      is_expected.not_to be_text
      is_expected.not_to be_access
      is_expected.not_to be_preservation
      is_expected.not_to be_preservation_redacted
      is_expected.to be_service
      is_expected.not_to be_thumbnail
    end
  end

  context 'with a thumbnail type' do
    before { model.thumbnail! }

    it do
      is_expected.not_to be_text
      is_expected.not_to be_access
      is_expected.not_to be_preservation
      is_expected.not_to be_preservation_redacted
      is_expected.not_to be_service
      is_expected.to be_thumbnail
    end
  end

  context 'field_type is bogus' do
    let(:model) { MyFileModel.new(use: 'bogus') }

    it 'raises an error' do
      expect { model }.to raise_error(Dry::Struct::Error)
    end
  end
end
