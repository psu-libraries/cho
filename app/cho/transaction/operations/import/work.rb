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
          file_sets = saved_file_sets(change_set.import_work)
          change_set.file_set_ids = file_sets.map(&:id)
          Success(change_set)
        rescue StandardError => exception
          Failure("Error importing the work: #{exception.message}")
        end

        private

          # @param [Import::Work] import_work
          # @return [Array<Work::FileSet>]
          def saved_file_sets(import_work)
            import_work.file_sets.map do |file_set|
              metadata_adapter.persister.save(resource: import_file_set(file_set))
            end
          end

          # @param [Import::FileSet] file_set
          # @return [Work::FileSet]
          def import_file_set(file_set)
            files = saved_files(file_set.files)
            ::Work::FileSet.new(member_ids: files.map(&:id), title: file_set.title)
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
              original_filename: file.original_filename
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
