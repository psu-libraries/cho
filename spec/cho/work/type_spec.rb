# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work::Type do
  let(:resource_klass) { described_class }

  it_behaves_like 'a Valkyrie::Resource'

  describe '#label' do
    it 'is nil when not set' do
      expect(resource_klass.new.label).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(label: 'test')
      expect(resource.attributes[:label]).to eq('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:label)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:label)
    end
  end

  describe '#display_schema' do
    it 'is nil when not set' do
      expect(resource_klass.new.metadata_schema_id).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(metadata_schema_id: 'test')
      expect(resource.attributes[:metadata_schema_id]).to eq(Valkyrie::ID.new('test'))
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:metadata_schema_id)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:metadata_schema_id)
    end
  end

  describe '#processing_schema' do
    it 'is nil when not set' do
      expect(resource_klass.new.processing_schema).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(processing_schema: 'test')
      expect(resource.attributes[:processing_schema]).to eq('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:processing_schema)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:processing_schema)
    end
  end

  describe '#display_schema' do
    it 'is nil when not set' do
      expect(resource_klass.new.display_schema).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(display_schema: 'test')
      expect(resource.attributes[:display_schema]).to eq('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:display_schema)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:display_schema)
    end
  end
end
