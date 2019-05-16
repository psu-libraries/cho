# frozen_string_literal: true

FactoryBot.define do
  factory :archival_collection, aliases: [:collection, :public_collection], class: Collection::Archival do
    title { 'Archival Collection' }
    subtitle { 'subtitle for an archival collection' }
    description { 'Sample archival collection' }
    workflow { 'default' }
    access_level { Repository::AccessLevel.public }

    factory :psu_collection do
      access_level { Repository::AccessLevel.psu }
      read_groups { [Repository::AccessLevel.psu] }
    end
  end
end
