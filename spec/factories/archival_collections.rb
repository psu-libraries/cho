# frozen_string_literal: true

FactoryBot.define do
  factory :archival_collection, aliases: [:collection], class: Collection::Archival do
    title { 'Archival Collection' }
    subtitle { 'subtitle for an archival collection' }
    description { 'Sample archival collection' }
    workflow { 'default' }
    access_level { Repository::AccessLevel.public }
  end
end
