# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Collection::Library, type: :model do
  let(:resource_klass) { described_class }

  it 'has a human-readable parameter name' do
    expect(resource_klass.model_name.param_key).to eq('library_collection')
  end

  it_behaves_like 'a collection'
  it_behaves_like 'a Valkyrie::Resource'
end
