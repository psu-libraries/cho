# frozen_string_literal: true

json.array! @metadata_application_profile_fields.to_a, partial: 'metadata_field', as: :metadata_application_profile_field
