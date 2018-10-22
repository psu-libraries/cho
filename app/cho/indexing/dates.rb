# frozen_string_literal: true

module Indexing
  class Dates
    attr_reader :resource
    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      solr_document = {}
      date_fields.each do |date|
        solr_document.merge!(solr_field(date))
      end
      solr_document
    end

    private

      # @note We might need to narrow down the scope of the query to only return fields specifically
      #   defined for the particular resource.
      def date_fields
        @date_fields ||= Schema::MetadataField.where(index_type: 'date').select do |field|
          resource.attributes[field.label.to_sym].present?
        end.to_a
      end

      def solr_field(date)
        value = solr_date(resource.attributes[date.label.to_sym])
        { date.solr_field => (date.multiple? ? value : value.first) }
      rescue ArgumentError
        {}
      end

      def solr_date(values)
        Array.wrap(values).map do |value|
          converted_date(value)
        end
      end

      # @note Valkyrie will attempt to cast Valkyrie::Types::Date types to a Time object. If that
      #   is unsuccessful, a string is returned.
      def converted_date(value)
        if value.is_a?(String)
          DateTime.iso8601(Date.edtf(value).to_s, Date::ENGLAND).utc.strftime(date_format)
        else
          value.utc.strftime(date_format)
        end
      end

      def date_format
        '%Y-%m-%dT%H:%M:%SZ'
      end
  end
end
