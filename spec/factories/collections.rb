# frozen_string_literal: true

FactoryGirl.define do
  factory :collection, aliases: [:archival_collection] do
    title 'Archival Collection'
    description 'Sample archival collection'
    collection_type 'archival'

    factory :library_collection do
      title 'Library Collection'
      description 'Sample library collection'
      collection_type 'library'
    end

    factory :curated_collection do
      title 'Curated Collection'
      description 'Sample curated collection'
      collection_type 'curated'
    end

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end
end
