# frozen_string_literal: true

module Indexing
  class DateRanges
    attr_reader :resource

    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      solr_document = {}
      edtf_fields.each do |edtf_field|
        solr_document.merge! field_to_date_range(edtf_field)
      end
      solr_document
    end

    private

      def edtf_fields
        @edtf_fields ||= Schema::MetadataField
          .where(validation: 'edtf_date')
          .select do |field|
            resource.attributes[field.label.to_sym].present?
          end
          .to_a
      end

      def field_to_date_range(field)
        value = solr_field_value(field)
        return {} if value.blank? || value.empty?

        { solr_field_name(field) => value }
      end

      def solr_field_name(field)
        suffix = 'dtrsi'
        suffix = "#{suffix}m" if field.multiple?

        "#{field.label}_#{suffix}"
      end

      def solr_field_value(field)
        value = resource.attributes[field.label.to_sym]

        converted_value = Array.wrap(value)
          .map { |v| EdtfDateRangeFormatter.format(v) }
          .compact

        field.multiple? ? converted_value : converted_value.first
      end
  end
end
