# frozen_string_literal: true

module Indexing
  class LinkedFields
    attr_reader :resource
    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      solr_document = {}
      linked_fields.each do |field|
        solr_document.merge!(solr_fields(field))
      end
      solr_document
    end

    private

      # @note Creators are the only kinds of linked fields at the moment, so this needs to be
      #       make more generic to handle different kinds of linked fields in the future.
      def linked_fields
        @linked_fields ||= Schema::MetadataField.where(index_type: 'linked_field').select do |field|
          resource.attributes[field.label.to_sym].present?
        end.to_a
      end

      def solr_fields(field)
        solrizer_class = Indexing.const_get(field.label.capitalize)
        solrizer_class.new(solr_field: field.solr_field, values: resource.attributes[field.label.to_sym]).to_solr
      rescue NameError
        {}
      end
  end
end
