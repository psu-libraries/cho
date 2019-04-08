# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindUsing do
  let(:query_service)  { Valkyrie.config.metadata_adapter.query_service }
  let(:saved_resource) { Valkyrie.config.metadata_adapter.persister.save(resource: sample_resource) }

  before(:all) do
    class SampleResource < Valkyrie::Resource
      include Valkyrie::Resource::AccessControls
      include DataDictionary::FieldsForObject

      attribute :framjam, Valkyrie::Types::String
      attribute :flimjam, Valkyrie::Types::String
    end

    class SimilarResource < Valkyrie::Resource
      include Valkyrie::Resource::AccessControls
      include DataDictionary::FieldsForObject

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

    context 'when providing multiple terms' do
      before do
        resource = SampleResource.new(framjam: 'some label', flimjam: 'label')
        Valkyrie.config.metadata_adapter.persister.save(resource: resource)
      end

      let(:sample_resource)    { SampleResource.new(framjam: 'some label', flimjam: 'another label') }
      let(:retrieved_resource) {
        query_service.custom_queries.find_using(framjam: 'some label', flimjam: 'another label').first
      }

      its(:id) { is_expected.to eq(retrieved_resource.id) }
    end
  end

  context 'without a saved resource' do
    subject { query_service.custom_queries.find_using(framjam: 'some label').first }

    it { is_expected.to be_nil }
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

  context 'when escaping punctuation in the search term' do
    let(:retrieved_resource) { query_service.custom_queries.find_using(framjam: "Pot 'o Gold").first }

    before do
      resource = SampleResource.new(framjam: "Pot 'o Gold")
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end

    it 'retrieves the correct resource' do
      expect(retrieved_resource.framjam).to eq("Pot 'o Gold")
    end
  end
end
