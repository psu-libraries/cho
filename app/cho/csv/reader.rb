# frozen_string_literal: true

require 'csv'

module Csv
  class Reader
    include ::CsvParsing

    attr_reader :headers, :csv_hashes

    delegate :each, :map, to: :csv_hashes

    def initialize(csv_file)
      csv_data = ::CSV.parse(csv_file)
      @headers = csv_data.shift
      @csv_hashes = csv_data.map { |a| Hash[@headers.zip(format_csv_data(a))] }
    end

    private

      def format_csv_data(data_array)
        data_array.map do |value|
          if value.present? && value.include?(VALUE_SEPARATOR)
            value.split(VALUE_SEPARATOR)
          else
            value
          end
        end
      end
  end
end
