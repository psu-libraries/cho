# frozen_string_literal: true

require 'csv'

module DataDictionary
  class CsvImporter
    attr_reader :file, :lines, :attributes

    def self.load_dictionary(dictionary_file = nil)
      dictionary_file ||= Rails.root.join('config', 'data_dictionary', "data_dictionary_#{Rails.env.downcase}.csv")
      importer = new(File.new(dictionary_file))
      importer.import
    end

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
          dictionary_field = parse_field(line)
          store_field(dictionary_field)
        end
      end

      def parse_field(line)
        csv_field = CsvField.new(Field.new, attributes)
        csv_field.parse(line)
      end

      # @param [DataDictionary::Field] dictionary_field
      def store_field(dictionary_field)
        change_set = find_existing_field(dictionary_field)
        change_set.validate(dictionary_field.attributes.slice(attributes))
        adapter.persister.save(resource: change_set)
      end

      # @param [DataDictionary::Field] dictionary_field
      # @return [DataDictionary::FieldChangeSet]
      def find_existing_field(dictionary_field)
        existing_field = adapter.query_service.custom_queries.find_using(label: dictionary_field.label).first
        FieldChangeSet.new(existing_field || dictionary_field)
      end

      def adapter
        @query_service ||= Valkyrie.config.metadata_adapter
      end
  end
end
