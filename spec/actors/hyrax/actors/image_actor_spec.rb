# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Image`
require 'rails_helper'

RSpec.describe Hyrax::Actors::ImageActor do
  it 'has tests' do
    expect(described_class.new(nil)).to respond_to(:create)
  end
end
