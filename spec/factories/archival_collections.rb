# frozen_string_literal: true

FactoryGirl.define do
  factory :archival_collection, class: Collection::Archival do
    title 'Archival Collection'
    subtitle 'subtitle for an archival collection'
    description 'Sample archival collection'
    workflow 'default'
    visibility 'public'

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end
end
