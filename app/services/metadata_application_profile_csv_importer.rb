# frozen_string_literal: true

require 'csv'

class MetadataApplicationProfileCsvImporter
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
      attributes = attributes & MetadataApplicationProfileField.attribute_names
      if attributes.blank?
        attributes = CsvMetadataApplicationProfileField.default_attributes
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
      csv_field = CsvMetadataApplicationProfileField.new(MetadataApplicationProfileField.new, attributes)
      csv_field.parse(line)
    end

    def store_field(metadata_field)
      field = find_existing_field(metadata_field)
      field ||= metadata_field
      field.save
    end

    def find_existing_field(metadata_field)
      existing_field = MetadataApplicationProfileField.find_by(label: metadata_field.label)
      existing_field&.assign_attributes(metadata_field.attributes.slice(attributes))
      existing_field
    end
end
