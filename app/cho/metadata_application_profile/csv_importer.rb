# frozen_string_literal: true

require 'csv'

module MetadataApplicationProfile
  class CsvImporter
    attr_reader :file, :lines, :attributes

    def initialize(file)
      @file = file
    end

    def import
      read_in_file
      parse_headers
      parse_data
    end

    private

      def read_in_file
        @lines = file.readlines
      end

      def parse_headers
        attributes = []
        ::CSV.parse(lines.first) { |row| attributes = row.map(&:parameterize).map(&:underscore) }
        attributes = attributes.map(&:to_sym) & Field.attribute_names
        if attributes.blank?
          attributes = CsvField.default_attributes
        else
          lines.shift
        end
        @attributes = attributes
      end

      def parse_data
        lines.each do |line|
          metadata_field = parse_field(line)
          store_field(metadata_field)
        end
      end

      def parse_field(line)
        csv_field = CsvField.new(Field.new, attributes)
        csv_field.parse(line)
      end

      # @param [MetadataApplicationProfile::Field] metadata_field
      def store_field(metadata_field)
        change_set = find_existing_field(metadata_field)
        change_set.validate(metadata_field.attributes.slice(attributes))
        adapter.persister.save(resource: change_set)
      end

      # @param [MetadataApplicationProfile::Field] metadata_field
      # @return [MetadataApplicationProfile::FieldChangeSet]
      def find_existing_field(metadata_field)
        existing_field = adapter.query_service.custom_queries.find_using(label: metadata_field.label).first
        FieldChangeSet.new(existing_field || metadata_field)
      end

      def adapter
        @query_service ||= Valkyrie.config.metadata_adapter
      end
  end
end
