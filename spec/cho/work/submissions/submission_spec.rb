# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work::Submission do
  let(:resource_klass) { described_class }

  it_behaves_like 'a Valkyrie::Resource'

  describe '#title' do
    it 'is nil when not set' do
      expect(resource_klass.new.title).to be_empty
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(title: 'test')
      expect(resource.attributes[:title]).to contain_exactly('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:title)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:title)
    end
  end

  describe '#work_type' do
    it 'is nil when not set' do
      expect(resource_klass.new.work_type).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(work_type: 'test')
      expect(resource.attributes[:work_type]).to eq('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:work_type)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:work_type)
    end
  end
end
