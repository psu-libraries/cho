# frozen_string_literal: true

module DataDictionary
  class Field < Valkyrie::Resource
    include WithRequirementDesignation
    include WithFieldType
    include WithValidation
    include WithVocabularies
    include WithDisplayTransformation
    include WithIndexType
    include CommonQueries

    attribute :id, Valkyrie::Types::ID.optional
    attribute :label, Valkyrie::Types::String
    attribute :default_value, Valkyrie::Types::String
    attribute :display_name, Valkyrie::Types::String
    attribute :multiple, Valkyrie::Types::Strict::Bool
    attribute :help_text, Valkyrie::Types::String
    attribute :core_field, Valkyrie::Types::Strict::Bool

    def multiple?
      return false if multiple.nil?
      multiple
    end
  end
end
