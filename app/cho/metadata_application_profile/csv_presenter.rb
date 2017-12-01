# frozen_string_literal: true

require 'csv'

module MetadataApplicationProfile
  class CsvPresenter
    attr_reader :metadata_application_profile_field_list, :export_attributes

    def initialize(metadata_application_profile_field_list, attributes = CsvField.default_attributes)
      attribute_symbols = attributes.map(&:to_sym)
      @export_attributes = (attribute_symbols & Field.attribute_names).map(&:to_s)
      @metadata_application_profile_field_list = metadata_application_profile_field_list
    end

    def to_csv
      csv_header + csv_lines
    end

    private

      def csv_header
        headers = export_attributes.map(&:titleize)
        ::CSV.generate_line(headers)
      end

      def csv_lines
        metadata_application_profile_field_list.map do |metadata_field|
          csv_line(metadata_field)
        end.join('')
      end

      def csv_line(metadata_field)
        return '' if metadata_field.blank?

        CsvField.new(metadata_field, export_attributes).to_csv
      end
  end
end
