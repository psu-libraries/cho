# frozen_string_literal: true

FactoryBot.define do
  factory :curated_collection, aliases: [:public_curated_collection], class: Collection::Curated do
    title { 'Curated Collection' }
    description { 'Sample curated collection' }
    subtitle { 'subtitle for a curated collection' }
    workflow { 'default' }
    access_rights { Repository::AccessControls::AccessLevel.public }

    factory :psu_curated_collection do
      access_rights { Repository::AccessControls::AccessLevel.psu }
      read_groups { [Repository::AccessControls::AccessLevel.psu] }
    end

    factory :private_curated_collection, aliases: [:restricted_curated_collection] do
      access_rights { Repository::AccessControls::AccessLevel.restricted }
      read_groups { [] }
    end
  end
end
