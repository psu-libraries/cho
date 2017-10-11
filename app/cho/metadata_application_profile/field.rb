# frozen_string_literal: true

module MetadataApplicationProfile
  class Field < ApplicationRecord
    self.table_name = 'metadata_application_profile_fields'
    include WithRequirementDesignation
    include WithFieldType
    include WithValidation
  end
end
