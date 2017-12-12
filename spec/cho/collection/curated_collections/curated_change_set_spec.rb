# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::CuratedChangeSet do
  subject { described_class }

  its(:ancestors) { is_expected.to include(Valkyrie::ChangeSet) }
end
