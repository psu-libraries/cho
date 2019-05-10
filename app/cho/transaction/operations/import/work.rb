# frozen_string_literal: true

module Transaction
  module Operations
    module Import
      class Work
        include Dry::Transaction::Operation

        attr_reader :model

        # @param [Work::SubmissionChangeSet] change_set
        def call(change_set)
          return Success(change_set) if change_set.try(:import_work).nil?

          @model = change_set.model
          file_sets = saved_file_sets(change_set.import_work, file_set_hashes: change_set.file_set_hashes)
          change_set.member_ids = file_sets.map(&:id)
          Success(change_set)
        rescue StandardError => e
          Failure(Transaction::Rejection.new("Error importing the work: #{e.message}"))
        end

        private

          # @param [Import::Work] import_work
          # @return [Array<Work::FileSet>]
          def saved_file_sets(import_work, file_set_hashes:)
            import_work.file_sets.map do |file_set|
              file_set_change_set = change_set_from_hash(file_set: file_set, file_set_hashes: file_set_hashes)
              resource = import_file_set(file_set, file_set_change_set: file_set_change_set)
              metadata_adapter.persister.save(resource: resource)
            end
          end

          # @return [Work::FileSetChangeSet]
          # @note matches an import file set obtained from the bag, to one of the hashes obtained in the csv
          def change_set_from_hash(file_set:, file_set_hashes:)
            file_set_hashes.select do |hash|
              hash.alternate_ids.map(&:to_s) == Array.wrap(file_set.id)
            end.first
          end

          # @param [Import::FileSet] file_set
          # @return [Work::FileSet]
          def import_file_set(file_set, file_set_change_set: nil)
            files = saved_files(file_set.files)
            file_set = if file_set_change_set.nil?
                         ::Work::FileSet.new(
                           member_ids: files.map(&:id),
                           title: file_set.title,
                           alternate_ids: file_set.id
                         )
                       else
                         file_set_change_set.member_ids = files.map(&:id)
                         file_set_change_set.sync
                         file_set_change_set.resource
                       end

            extracted_text = FileSet::ExtractText.new.call(file_set)

            # @todo If text extraction fails, the file set is returned anyway, but we ought to register
            #   the failure somehow so extraction can re-run later.
            if extracted_text.failure?
              file_set
            else
              extracted_text.success
            end
          end

          # @param [Array<Import::File>] files
          # @return [Array<Work::File>]
          def saved_files(files)
            files.map do |file|
              metadata_adapter.persister.save(resource: import_file(file))
            end
          end

          # @param [Import::File] file
          # @return [Work::File]
          def import_file(file)
            ::Work::File.new(
              file_identifier: adapter_file(file).id,
              original_filename: file.original_filename,
              use: file.type
            )
          end

          def adapter_file(file)
            storage_adapter.upload(
              file: file,
              original_filename: file.original_filename,
              resource: model
            )
          end

          def storage_adapter
            @storage_adapter ||= Valkyrie.config.storage_adapter
          end

          def metadata_adapter
            @metadata_adapter ||= Valkyrie::MetadataAdapter.find(:indexing_persister)
          end
      end
    end
  end
end
