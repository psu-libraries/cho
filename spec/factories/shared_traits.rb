# frozen_string_literal: true

FactoryBot.define do
  trait :restricted_to_penn_state do
    read_groups { [Repository::AccessControls::AccessLevel.psu] }
  end

  trait :restricted do
    read_groups { [] }
  end
end
