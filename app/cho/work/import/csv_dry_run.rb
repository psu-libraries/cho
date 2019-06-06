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
    #   The header items correspond to a field in the data dictionary: home_collection_id, work_type_id, title.
    #
    class CsvDryRun
      include Csv::DryRunBehavior

      # @param [String] csv_file_name
      # @param [true, false] update
      def initialize(csv_file_name, update: false)
        @update = update
        @reader = CsvReader.new(::File.new(csv_file_name, 'r', encoding: 'bom|utf-8'))
        validate_structure
        results
        add_import_works
      end

      def bag
        @bag ||= if update?
                   Dry::Monads::Result::Failure.new('Bags are not supported with CSVDryRun updates')
                 else
                   Transaction::Import::ImportFromZip.new.call(zip_name: batch_id)
                 end
      end

      def results
        @results ||= reader.map.with_index do |work_hash, index|
          add_order_index!(work_hash, index) unless update?
          WorkHashValidator.new(work_hash,
                                resource_class: Work::Submission,
                                change_set_class: Work::SubmissionChangeSet).change_set
        end
      end

      private

        def add_order_index!(work_hash, index)
          order_index = num_works_in_home_collection(work_hash) + index + 1
          work_hash.merge!(order_index: order_index)
        end

        def num_works_in_home_collection(work_hash)
          collection_id = work_hash['home_collection_id']

          @num_works_in_home_collection ||= {}
          @num_works_in_home_collection.fetch(collection_id) do
            @num_works_in_home_collection[collection_id] = load_num_works_in_collection(collection_id)
          end
        end

        def load_num_works_in_collection(home_collection_id)
          Valkyrie.config.metadata_adapter.query_service
            .find_by_alternate_identifier(alternate_identifier: home_collection_id)
            .members
            .count
        rescue Valkyrie::Persistence::ObjectNotFoundError
          0
        end

        # @note Attaches the import work and associated file set hashes to each change set. These will
        # be used later in the transaction when the file sets and files are created or updated.
        def add_import_works
          results.each do |change_set|
            change_set.import_work = retrieve_import_work(change_set: change_set)
            change_set.file_set_hashes = build_file_sets(change_set: change_set).compact
          end
        end

        # @return [Import::Work] retrieved from the bag based on the alternate id provided in the CSV.
        # @note If the bag is a failure, it could indicate a bad bag, or just an update.
        def retrieve_import_work(change_set:)
          return if bag.failure?

          bag.success.works.select { |work| work.identifier == change_set.alternate_ids.first.to_s }.first
        end

        # @return [Array<Work::FileSetChangeSet>]
        def build_file_sets(change_set:)
          if change_set.import_work.present?
            build_import_file_sets(change_set.import_work)
          else
            build_update_file_sets
          end
        end

        # @note This applies to a create scenario, where we select file set metadata from the CSV that matches
        # the id of the file sets in the import work.
        def build_import_file_sets(import_work)
          import_work.file_sets.map do |file_set|
            file_set_hash = file_set_metadata(file_set.id).first
            next if file_set_hash.nil?

            FileSetHashValidator.new(file_set_hash,
                                     resource_class: Work::FileSet,
                                     change_set_class: Work::FileSetChangeSet).change_set
          end
        end

        # @note This applies to an update scenario, where we read each file set from the csv. Since this is
        # assumed to be from a previously exported step, we assume the metadata is valid.
        def build_update_file_sets
          reader.file_set_hashes.map do |file_set|
            FileSetHashValidator.new(file_set,
                                     resource_class: Work::FileSet,
                                     change_set_class: Work::FileSetChangeSet).change_set
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
            'home_collection_id',
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
