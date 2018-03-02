# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Collection::Curated, type: :model do
  let(:resource_klass) { described_class }

  it 'has a human-readable parameter name' do
    expect(resource_klass.model_name.param_key).to eq('curated_collection')
  end

  describe '#members' do
    subject { resource_klass.new }

    its(:members) { is_expected.to be_empty }
  end

  it_behaves_like 'a Valkyrie::Resource'
end
