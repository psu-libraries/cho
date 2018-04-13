# frozen_string_literal: true

FactoryGirl.define do
  factory :library_collection, class: Collection::Library do
    title 'Library Collection'
    description 'Sample library collection'
    subtitle 'subtitle for a library collection'
    workflow 'default'
    visibility 'public'
  end
end
