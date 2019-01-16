# frozen_string_literal: true

module Agent
  module Import
    class CsvDryRun < Work::Import::CsvDryRun
      # @param [String] csv_file_name
      # @param [true, false] update
      def initialize(csv_file_name, update: false)
        @update = update
        @reader = CsvReader.new(::File.new(csv_file_name, 'r'))
        validate_structure
        results
        add_import_works
      end

      def results
        @results ||= reader.map do |work_hash|
          AgentHashValidator.new(work_hash).change_set
        end
      end

      private

        def invalid_fields
          reader.headers - ['given_name', 'surname', 'id']
        end
    end
  end
end
