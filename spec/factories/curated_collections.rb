# frozen_string_literal: true

FactoryBot.define do
  factory :curated_collection, aliases: [:public_curated_collection], class: Collection::Curated do
    title { 'Curated Collection' }
    description { 'Sample curated collection' }
    subtitle { 'subtitle for a curated collection' }
    workflow { 'default' }
    access_level { Repository::AccessLevel.public }

    factory :psu_curated_collection do
      access_level { Repository::AccessLevel.psu }
      read_groups { [Repository::AccessLevel.psu] }
    end

    factory :private_curated_collection, aliases: [:restricted_curated_collection] do
      access_level { Repository::AccessLevel.restricted }
      read_groups { [] }
    end
  end
end
