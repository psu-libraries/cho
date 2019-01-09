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
      "#{label}_#{suffix}"
    end

    # @return [String] field name used when this field is used for faceting
    def facet_field
      "#{label}_ssim"
    end

    # @return [Valkyrie::Types] property type for the Valkyrie::ChangeSet
    # @note This does not address multiple: valkyrie_id field types are singular, alternate_id types must be
    #    multiple; everything else is multiple.
    def change_set_property_type
      if valkyrie_id?
        Valkyrie::Types::ID.optional
      elsif alternate_id?
        Valkyrie::Types::Set.of(Valkyrie::Types::ID)
      elsif date?
        Valkyrie::Types::Set.of(Valkyrie::Types::Date)
      else
        Valkyrie::Types::Set.optional
      end
    end

    # @return [Valkyrie::Types] property type for the Valkyrie::Resource
    # @note This does not address multiple: valkyrie_id field types are singular, alternate_id types must be
    #    multiple; everything else is multiple.
    def resource_property_type
      if valkyrie_id?
        Valkyrie::Types::ID.optional
      elsif alternate_id?
        Valkyrie::Types::Set.of(Valkyrie::Types::ID)
      elsif date?
        Valkyrie::Types::Set.of(Valkyrie::Types::Date)
      else
        Valkyrie::Types::Set.meta(ordered: true)
      end
    end

    # @note This defined how the field should be addressed when creating dynamic methods for access
    #       in other classes such as the SolrDocument. Just the plain label is not necessarily unique enough
    #       to be used so we are adding a suffix to avoid collisions with other methods
    def method_name
      "#{label}_data_dictionary_field"
    end

    private

      def suffix
        return 'ssim' if valkyrie_id? || alternate_id?
        return "dtsi#{multiple_suffix}" if date?

        'tesim'
      end

      def multiple_suffix
        return unless multiple?

        'm'
      end
  end
end
