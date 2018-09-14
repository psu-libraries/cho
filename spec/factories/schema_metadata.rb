# frozen_string_literal: true

FactoryBot.define do
  factory :schema_metadata, class: Schema::Metadata do
    sequence(:id)
    label { 'abc123_label' }

    to_create do |resource|
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end
  end
end
