# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Solr::SingularMetadataAdapter do
  subject { adapter }

  let(:adapter) do
    described_class.new(connection: Blacklight.default_index.connection)
  end

  it_behaves_like 'a Valkyrie::MetadataAdapter'

  its(:persister) { is_expected.to be_a Solr::SingularPersister }
end
