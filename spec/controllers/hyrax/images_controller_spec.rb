# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::ImagesController do
  it 'has tests' do
    expect(described_class.curation_concern_type).to eq(::Image)
  end
end
