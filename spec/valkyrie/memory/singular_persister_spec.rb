# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Memory::SingularPersister do
  let(:persister) { described_class.new(adapter) }
  let(:adapter) { Memory::SingularMetadataAdapter.new }
  let(:query_service) { adapter.query_service }

  context 'shared examples allowing singular values' do
    before do |example|
      # We are skipping the check for 'does not save non-array properties' since we are allowing singular values
      if example.description == 'does not save non-array properties'
        skip 'We are allowing Non Array Properties'
      end
    end

    it_behaves_like 'a Valkyrie::Persister'
  end
end
