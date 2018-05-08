# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Postgres::SingularMetadataAdapter do
  let(:adapter) do
    described_class.new
  end

  it_behaves_like 'a Valkyrie::MetadataAdapter'

  its(:persister) { is_expected.to be_a Postgres::SingularPersister }
end
