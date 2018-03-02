# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Channel do
  it { expect(described_class).to be < ActionCable::Channel::Base }
end
