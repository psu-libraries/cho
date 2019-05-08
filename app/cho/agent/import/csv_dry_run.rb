# frozen_string_literal: true

module Agent
  module Import
    class CsvDryRun
      include Csv::DryRunBehavior

      # @param [String] csv_file_name
      # @param [true, false] update
      def initialize(csv_file_name, update: false)
        @update = update
        @reader = Csv::Reader.new(::File.new(csv_file_name, 'r', encoding: 'bom|utf-8'))
        validate_structure
        results
      end

      def results
        @results ||= reader.map do |work_hash|
          Csv::HashValidator.new(work_hash,
                                 resource_class: Agent::Resource,
                                 change_set_class: Agent::ChangeSet).change_set
        end
      end

      private

        def invalid_fields
          reader.headers - ['given_name', 'surname', 'id']
        end
    end
  end
end
