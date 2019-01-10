# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Indexing::LinkedFields do
  let(:resource) { Work::Submission.new }
  let(:indexer) { described_class.new(resource: resource) }

  describe '#to_solr' do
    subject { indexer.to_solr }

    context 'when the field is empty' do
      it { is_expected.to eq({}) }
    end

    context 'with null creator values' do
      before { resource.creator = [{ role: '', agent: '' }] }

      it do
        is_expected.to eq(
          'creator_tesim' => [],
          'creator_agent_tesim' => [],
          'creator_role_tesim' => [],
          'creator_role_ssim' => [],
          'creator_agent_id_ssim' => [''],
          'creator_role_id_ssim' => ['']
        )
      end
    end

    context 'when specifying a creator' do
      let(:agent) { create(:agent, given_name: 'Bud', surname: 'Fox') }

      before { resource.creator = [{ role: MockRDF.relators.first.to_uri.to_s, agent: agent.id }] }

      it do
        is_expected.to eq(
          'creator_tesim' => ['Fox, Bud, blasting'],
          'creator_agent_tesim' => ['Bud Fox'],
          'creator_role_tesim' => ['blasting'],
          'creator_role_ssim' => ['blasting'],
          'creator_agent_id_ssim' => [agent.id.to_s],
          'creator_role_id_ssim' => [MockRDF.relators.first.to_uri.to_s]
        )
      end
    end

    context 'when a solrizer class does not exist' do
      let(:mock_field) { instance_double(Schema::MetadataField, label: 'foo') }

      before { allow(indexer).to receive(:linked_fields).and_return([mock_field]) }

      it { is_expected.to eq({}) }
    end
  end
end
