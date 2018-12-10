# frozen_string_literal: true

module DataDictionary
  class CreatorFieldType < LinkedFieldType
    def initialize(subject:, role:, agent:)
      # @todo Should we be verifying the class types here?
      super(subject: subject, predicate: role, object: agent)
    end

    alias_method :role, :predicate
    alias_method :agent, :object
  end
end
