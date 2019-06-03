# frozen_string_literal: true

FactoryBot.define do
  factory :library_collection, aliases: [:public_library_collection], class: Collection::Library do
    title { 'Library Collection' }
    description { 'Sample library collection' }
    subtitle { 'subtitle for a library collection' }
    workflow { 'default' }
    access_level { Repository::AccessLevel.public }

    factory :psu_library_collection do
      access_level { Repository::AccessLevel.psu }
      read_groups { [Repository::AccessLevel.psu] }
    end

    factory :private_library_collection, aliases: [:restricted_library_collection] do
      access_level { Repository::AccessLevel.restricted }
      read_groups { [] }
    end
  end
end
