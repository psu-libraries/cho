# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindModel do
  let(:query_service)  { Valkyrie.config.metadata_adapter.query_service }
  let(:saved_resource) { Valkyrie.config.metadata_adapter.persister.save(resource: sample_resource) }

  before(:all) do
    class SpecialModel < Valkyrie::Resource
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('SpecialModel')
  end

  context 'with a saved resource' do
    subject { saved_resource }

    let(:sample_resource)    { SpecialModel.new }
    let(:retrieved_resource) { query_service.custom_queries.find_model(
      model: saved_resource.class,
      id: saved_resource.id
    ) }

    its(:id) { is_expected.to eq(retrieved_resource.id) }
  end

  context 'without a saved resource' do
    subject { query_service.custom_queries.find_model(model: 'Foo', id: id) }

    let(:id) { Valkyrie::ID.new('1') }

    it { is_expected.to be_nil }
  end

  context 'with a non-Valkyrie id' do
    it 'raises an error' do
      expect {
        query_service.custom_queries.find_model(model: 'Foo', id: '1')
      }.to raise_error(ArgumentError, 'id must be a Valkyrie::ID')
    end
  end
end
