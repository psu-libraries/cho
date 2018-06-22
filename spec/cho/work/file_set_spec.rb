# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work::FileSet do
  let(:resource_klass) { described_class }

  it_behaves_like 'a Valkyrie::Resource'

  describe 'member_ids' do
    its(:member_ids) { is_expected.to be_empty }
  end
end
