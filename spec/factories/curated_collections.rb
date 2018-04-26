# frozen_string_literal: true

FactoryBot.define do
  factory :curated_collection, class: Collection::Curated do
    title 'Curated Collection'
    description 'Sample curated collection'
    subtitle 'subtitle for a curated collection'
    workflow 'default'
    visibility 'public'
  end
end
