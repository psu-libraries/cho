# frozen_string_literal: true

module DataDictionary::WithRequirementDesignation
  extend ActiveSupport::Concern

  RequirementDesignations = Valkyrie::Types::String.enum('required_to_publish', 'recommended', 'optional')

  included do
    attribute :requirement_designation, RequirementDesignations
  end

  def required_to_publish!
    self.requirement_designation = 'required_to_publish'
  end

  def required_to_publish?
    requirement_designation == 'required_to_publish'
  end

  def recommended!
    self.requirement_designation = 'recommended'
  end

  def recommended?
    requirement_designation == 'recommended'
  end

  def optional!
    self.requirement_designation = 'optional'
  end

  def optional?
    requirement_designation == 'optional'
  end
end
