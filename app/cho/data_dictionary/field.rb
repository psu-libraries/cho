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

    def self.core_fields
      @core_fields ||= where(core_field: true).sort_by(&:created_at)
    end

    def multiple?
      return false if multiple.nil?
      multiple
    end

    # @return [String] field name used in Solr for indexing
    def solr_field
      if field_type == 'date'
        "#{label}_dtsi"
      elsif field_type == 'valkyrie_id'
        "#{label}_ssim"
      else
        "#{label}_tesim"
      end
    end

    # @return [Valkyrie::Types] property type for the Valkyrie::ChangeSet
    # @note This does not address multiple, it only assumes valkyrie_id field types are singular
    #    and everything else is multiple
    def change_set_property_type
      return Valkyrie::Types::Set.optional unless valkyrie_id?
      Valkyrie::Types::ID.optional
    end

    # @return [Valkyrie::Types] property type for the Valkyrie::Resource
    # @note This does not address multiple, it only assumes valkyrie_id field types are singular
    #    and everything else is multiple
    def resource_property_type
      return Valkyrie::Types::Set.meta(ordered: true) unless valkyrie_id?
      Valkyrie::Types::ID.optional
    end

    # @note This defined how the field should be addressed when creating dynamic methods for access
    #       in other classes such as the SolrDocument. Just the plain label is not necessarily unique enough
    #       to be used so we are adding a suffix to avoid collisions with other methods
    def method_name
      "#{label}_data_dictionary_field"
    end
  end
end
