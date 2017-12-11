# frozen_string_literal: true

json.extract! data_dictionary_field, :label, :field_type, :requirement_designation, :validation, :multiple, :controlled_vocabulary, :default_value, :display_name, :display_transformation
json.url data_dictionary_field_url(data_dictionary_field, format: :json)
