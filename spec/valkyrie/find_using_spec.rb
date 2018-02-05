# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindUsing do
  let(:query_service)  { Valkyrie.config.metadata_adapter.query_service }
  let(:saved_resource) { Valkyrie.config.metadata_adapter.persister.save(resource: sample_resource) }

  before(:all) do
    class SampleResource < Valkyrie::Resource
      include Valkyrie::Resource::AccessControls
      include DataDictionary::FieldsForObject
      attribute :id, Valkyrie::Types::ID.optional
      attribute :framjam, Valkyrie::Types::String
    end

    class SimilarResource < Valkyrie::Resource
      include Valkyrie::Resource::AccessControls
      include DataDictionary::FieldsForObject
      attribute :id, Valkyrie::Types::ID.optional
      attribute :framjam, Valkyrie::Types::String
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('SampleResource')
    ActiveSupport::Dependencies.remove_constant('SimilarResource')
  end

  context 'with a saved resource' do
    subject { saved_resource }

    let(:sample_resource)    { SampleResource.new(framjam: 'some label') }
    let(:retrieved_resource) { query_service.custom_queries.find_using(framjam: 'some label').first }

    its(:framjam) { is_expected.to eq(retrieved_resource.framjam) }
  end

  context 'without a saved resource' do
    subject { query_service.custom_queries.find_using(framjam: 'some label').first }

    it { is_expected.to be_nil }
  end

  context 'when providing multiple terms' do
    it 'raises and error' do
      expect {
        query_service.custom_queries.find_using(framjam: 'some label', flimjam: 'another label')
      }.to raise_error(ArgumentError, 'only one query term is supported')
    end
  end

  context 'when providing a model' do
    subject { saved_resource }

    let(:sample_resource) { SampleResource.new(framjam: 'testing with model') }
    let(:similar_resource) { SimilarResource.new(framjam: 'testing with model') }

    it 'retrieves the specific model of resource' do
      persisted_sample = Valkyrie.config.metadata_adapter.persister.save(resource: sample_resource)
      Valkyrie.config.metadata_adapter.persister.save(resource: similar_resource)
      results = query_service.custom_queries.find_using(framjam: 'testing with model', model: SampleResource)
      expect(results.count).to eq(1)
      expect(results.first.id).to eq(persisted_sample.id)
    end
  end
end
