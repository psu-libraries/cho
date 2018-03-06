# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrFacade do
  let(:solr_facade) { described_class.new(repository: repository, query: query, current_page: 2, per_page: 11) }
  let(:repository) { instance_double(Blacklight::Solr::Repository) }
  let(:query) { 'a solr query' }
  let(:response) { instance_double(Blacklight::Solr::Response) }
  let(:response_documents) { [instance_double(SolrDocument)] }

  describe '#query_response' do
    before do
      allow(repository).to receive(:search).and_return(response)
    end
    it 'queries the Solr index' do
      expect(repository).to receive(:search).with(query)
      expect(solr_facade.query_response).to eq response
    end
  end

  describe '#members' do
    before do
      allow(response).to receive(:documents).and_return(response_documents)
      allow(repository).to receive(:search).and_return(response)
    end
    it 'queries the Solr Index' do
      expect(solr_facade.members).to eq response_documents
    end
  end
end
