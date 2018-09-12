# frozen_string_literal: true

# An internal CHO resource used for defining terms on collections and works.
# Data dictionary terms are not indexed in Solr and are only persisted in Postgres via
# the {Postgres::SingularMetadataAdapter}.
module DataDictionary
  class Field < Valkyrie::Resource
    include WithRequirementDesignation
    include WithFieldType
    include WithValidation
    include WithVocabularies
    include WithDisplayTransformation
    include WithIndexType
    include CommonQueries

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

    def self.core_fields
      @core_fields ||= where(core_field: true).sort_by(&:created_at)
    end

    # @note This defined how the field should be addressed when creating dynamic methods for access
    #       in other classes such as the SolrDocument. Just the plain label is not necessarily unique enough
    #       to be used so we are adding a suffix to avoid collisions with other methods
    def method_name
      "#{label}_data_dictionary_field"
    end
  end
end
