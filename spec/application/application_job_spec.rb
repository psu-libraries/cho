# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationJob do
  it { expect(described_class).to be < ActiveJob::Base }
end
