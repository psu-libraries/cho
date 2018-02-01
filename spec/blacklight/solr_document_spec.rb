# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument, type: :model do
  before(:all) do
    class MyResource; end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyResource')
  end

  subject { SolrDocument.new(document) }

  let(:document) { { 'internal_resource_tsim' => 'MyResource' } }

  describe '#internal_resource' do
    its(:internal_resource) { is_expected.to be(MyResource) }
  end
end
