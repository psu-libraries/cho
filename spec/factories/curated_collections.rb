# frozen_string_literal: true

FactoryGirl.define do
  factory :curated_collection, class: Collection::Curated do
    title 'Curated Collection'
    description 'Sample curated collection'
    subtitle 'subtitle for a curated collection'
    workflow 'default'
    visibility 'public'

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end
end
