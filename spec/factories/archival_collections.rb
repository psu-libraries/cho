# frozen_string_literal: true

FactoryBot.define do
  factory :archival_collection, aliases: [:collection, :public_collection], class: Collection::Archival do
    title { 'Archival Collection' }
    subtitle { 'subtitle for an archival collection' }
    description { 'Sample archival collection' }
    workflow { 'default' }
    access_rights { Repository::AccessLevel.public }

    factory :psu_collection do
      access_rights { Repository::AccessLevel.psu }
      read_groups { [Repository::AccessLevel.psu] }
    end

    factory :private_collection, aliases: [:restricted_collection] do
      access_rights { Repository::AccessLevel.restricted }
      read_groups { [] }
    end
  end
end
