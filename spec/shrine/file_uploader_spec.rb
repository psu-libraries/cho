# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe FileUploader, type: :model do
  subject { described_class }

  it { is_expected.to be < Shrine }
end
