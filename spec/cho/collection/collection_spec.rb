# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Collection, type: :model do
  let(:resource_klass) { described_class }

  it_behaves_like 'a Valkyrie::Resource'

  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:collection_type) }
end
