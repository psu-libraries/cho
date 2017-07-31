# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Image do
  it 'has tests' do
    expect(described_class.new).to respond_to(:to_solr)
  end
end
