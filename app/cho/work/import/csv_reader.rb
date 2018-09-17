# frozen_string_literal: true

require 'csv'

module Work
  module Import
    class CsvReader
      include ::CsvParsing

      attr_reader :headers, :csv_hashes

      delegate :each, :map, to: :work_hashes

      def initialize(csv_file)
        csv_data = ::CSV.parse(csv_file)
        @headers = csv_data.shift
        @csv_hashes = csv_data.map { |a| Hash[@headers.zip(format_csv_data(a))] }
      end

      def work_hashes
        csv_hashes.reject { |hash| hash.fetch('member_of_collection_ids').nil? }
      end

      def file_set_hashes
        csv_hashes.select { |hash| hash.fetch('member_of_collection_ids').nil? }
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
end
