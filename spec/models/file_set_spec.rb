# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FileSet do
  it 'has tests' do
    expect(described_class.new).to respond_to(:to_solr)
  end
end
