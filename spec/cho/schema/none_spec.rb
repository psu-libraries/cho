# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schema::None do
  subject { described_class.new }

  its(:core_fields) { is_expected.to be_empty }
  its(:fields) { is_expected.to be_empty }
end
