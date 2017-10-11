# frozen_string_literal: true

module MetadataApplicationProfile::WithRequirementDesignation
  extend ActiveSupport::Concern

  included do
    enum requirement_designation: { required_to_publish: 'required to publish',
                                    recommended: 'recommended',
                                    optional: 'optional' }
  end
end
