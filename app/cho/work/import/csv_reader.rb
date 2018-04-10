# frozen_string_literal: true

module Work
  module Import
    class CsvReader
      attr_reader :headers, :csv_hashes

      delegate :each, :map, to: :csv_hashes

      def initialize(csv_file)
        csv_data = CSV.parse(csv_file)
        @headers = csv_data.shift
        @csv_hashes = csv_data.map { |a| Hash[@headers.zip(a)] }
      end
    end
  end
end
