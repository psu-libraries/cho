# frozen_string_literal: true

FactoryGirl.define do
  factory :archival_collection, class: Collection::Archival do
    title 'Archival Collection'
    subtitle 'subtitle for an archival collection'
    description 'Sample archival collection'
    workflow 'default'
    visibility 'public'
  end
end
