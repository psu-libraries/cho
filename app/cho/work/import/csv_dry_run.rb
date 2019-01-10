# frozen_string_literal: true

module Work
  module Import
    # Creates a list of change sets from the CSV file
    #  Each item in the list is a change set that can be persisted if valid.
    # @example
    #
    #   change_set_list = CSVDryRun.run('csv_data.csv')
    #
    #   The first line of the csv file is expected to be the header.
    #   The header items correspond to a field in the data dictionary: member_of_collection_ids, work_type_id, title.
    #
    class CsvDryRun
      include Csv::DryRunBehavior

      # @param [String] csv_file_name
      # @param [true, false] update
      def initialize(csv_file_name, update: false)
        @update = update
        @reader = CsvReader.new(::File.new(csv_file_name, 'r'))
        validate_structure
        results
        add_import_works
      end

      def bag
        @bag ||= Transaction::Import::ImportFromZip.new.call(zip_name: batch_id)
      end

      def results
        @results ||= reader.map do |work_hash|
          WorkHashValidator.new(work_hash).change_set
        end
      end

      private

        # @todo see https://github.com/psu-libraries/cho/issues/605
        # @note if there's more than one work in the bag with the same identifier, the duplicates will be ignored.
        def add_import_works
          return if bag.failure?

          results.each do |change_set|
            import_work = retrieve_import_work(change_set: change_set)
            change_set.import_work = import_work
            change_set.file_set_hashes = build_import_file_sets(import_work).compact if import_work.present?
          end
        end

        def retrieve_import_work(change_set:)
          bag.success.works.select { |work| work.identifier == change_set.alternate_ids.first.to_s }.first
        end

        def build_import_file_sets(import_work)
          import_work.file_sets.map do |file_set|
            file_set_hash = file_set_metadata(file_set.id).first
            next if file_set_hash.nil?

            FileSetHashValidator.new(file_set_hash).change_set
          end
        end

        def file_set_metadata(file_set_id)
          reader.file_set_hashes.select do |file_set|
            file_set.fetch('alternate_ids') == file_set_id
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
            'batch_id',
            'id'
          ]
        end

        def batch_id
          ids = results.map { |validator| validator['batch_id'] }.uniq
          raise Csv::ValidationError, 'CSV contains multiple or missing batch ids' if ids.count > 1

          ids.first
        end
    end
  end
end
