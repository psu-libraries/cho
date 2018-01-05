# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  subject { described_class.new(document) }

  describe '#model' do
    let(:document) { { internal_resource_ssim: ['MyModel'] } }

    its(:model) { is_expected.to eq('MyModel') }
  end
end
