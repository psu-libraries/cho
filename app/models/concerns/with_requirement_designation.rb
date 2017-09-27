# frozen_string_literal: true

module WithRequirementDesignation
  extend ActiveSupport::Concern

  included do
    enum requirement_designation: { required_to_publish: 'required to publish',
                                    recommended: 'recommended',
                                    optional: 'optional' }
  end
end
