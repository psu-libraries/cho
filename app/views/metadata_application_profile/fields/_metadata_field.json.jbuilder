# frozen_string_literal: true

json.extract! metadata_application_profile_field, :label, :field_type, :requirement_designation, :validation, :multiple, :controlled_vocabulary, :default_value, :display_name, :display_transformation
json.url metadata_application_profile_field_url(metadata_application_profile_field, format: :json)
