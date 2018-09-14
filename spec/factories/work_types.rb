# frozen_string_literal: true

FactoryBot.define do
  factory :work_type, class: Work::Type do
    label { 'Sample Work Type' }

    to_create do |resource|
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end
  end
end
