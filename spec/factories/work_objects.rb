# frozen_string_literal: true

FactoryGirl.define do
  factory :work_object, aliases: [:work] do
    title 'Sample Generic Work'
    work_type 'Generic'

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end
end
