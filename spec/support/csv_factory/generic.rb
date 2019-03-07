# frozen_string_literal: true

#
# Builds a generic csv file use for testing. It can be used to build any kind
# of csv file, with any number of rows and columns, without any restrictions.
module CsvFactory
  class Generic
    attr_reader :path

    # @param [Array<Hash>] data
    # @note each element of the data hash represents a column in the csv
    # @example
    #
    #   {
    #     column_one: ['row1', row2],
    #     column_two: ['row1', row2]
    #   }
    #
    #   Becomes:
    #
    #   | column_one | column_two |
    #   |------------|------------|
    #   | row1       | row1       |
    #   | row2       | row2       |
    #
    def initialize(data)
      Tempfile.open do |csv_file|
        csv_file.write(data.keys.to_csv)
        data.values.transpose.each { |array| csv_file.write(array.to_csv) }
        @path = csv_file.path
      end
    end

    def unlink
      FileUtils.rm_f(path)
    end

    private

      def line(content)
        "#{content}\n"
      end
  end
end
