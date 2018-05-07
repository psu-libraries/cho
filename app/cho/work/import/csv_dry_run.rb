# frozen_string_literal: true

module Work
  module Import
    # Creates a list of change sets from the CSV file
    #  Each item in the list is a change set that can be persisted if valid
    #
    # change_set_list = CSVDryRun.run('csv_data.csv')
    #
    # The first line of the csv file is expected to be the header.  The header items correspond to field in the datadictionary
    # member_of_collection_ids,work_type_id,title
    #
    class CsvDryRun
      attr_reader :update, :results, :reader

      class InvalidCsvError < StandardError; end

      # @param [String] csv_file_name
      # @param [true, false] update
      def initialize(csv_file_name, update: false)
        @update = update
        @reader = CsvReader.new(::File.new(csv_file_name, 'r'))
        validate_structure
        build_results
      end

      def update?
        update
      end

      private

        def validate_structure
          raise InvalidCsvError, "Unexpected column(s): '#{invalid_fields.join(', ')}'" if invalid_fields.present?
          if update?
            raise InvalidCsvError, 'Missing id column for update' unless reader.headers.include?('id')
          end
        end

        def build_results
          @results ||= reader.map do |work_hash|
            WorkHashValidator.new(work_hash).change_set
          end
        end

        # @param [CsvReader] reader
        # @return [Array] of fields that are invalid and do not exist in the data dictionary
        def invalid_fields
          reader.headers - DataDictionary::Field.all.map(&:label) - specialized_fields
        end

        # @note fields that are valid csv column names but are not found in the data dictionary
        def specialized_fields
          [
            'member_of_collection_ids',
            'work_type',
            'work_type_id',
            'file_name',
            'id'
          ]
        end
    end
  end
end
