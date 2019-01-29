# frozen_string_literal: true

FactoryBot.define do
  factory :schema_metadata_field, class: Schema::MetadataField do
    label { 'abc123_label' }
    field_type { 'date' }
    requirement_designation { 'recommended' }
    controlled_vocabulary { 'no_vocabulary' }
    default_value { 'abc123' }
    display_name { 'My Abc123' }
    display_transformation { 'no_transformation' }
    multiple { false }
    validation { 'no_validation' }
    help_text { 'help me' }
    index_type { 'no_facet' }
    core_field { false }
    order_index { 0 }
    work_type { 'Generic' }
    data_dictionary_field_id { 1 }

    to_create do |resource|
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end
  end
end
