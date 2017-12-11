# frozen_string_literal: true

require 'csv'

module DataDictionary
  class CsvPresenter
    attr_reader :data_dictionary_field_list, :export_attributes

    def initialize(data_dictionary_field_list, attributes = CsvField.default_attributes)
      attribute_symbols = attributes.map(&:to_sym)
      @export_attributes = (attribute_symbols & Field.attribute_names).map(&:to_s)
      @data_dictionary_field_list = data_dictionary_field_list
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
        data_dictionary_field_list.map do |dictionary_field|
          csv_line(dictionary_field)
        end.join('')
      end

      def csv_line(dictionary_field)
        return '' if dictionary_field.blank?

        CsvField.new(dictionary_field, export_attributes).to_csv
      end
  end
end
