# frozen_string_literal: true

FactoryBot.define do
  factory :library_collection, class: Collection::Library do
    title { 'Library Collection' }
    description { 'Sample library collection' }
    subtitle { 'subtitle for a library collection' }
    workflow { 'default' }
    access_level { Repository::AccessLevel.public }
  end
end
