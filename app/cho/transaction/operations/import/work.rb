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
          change_set.file_set_ids = file_sets.map(&:id)
          Success(change_set)
        rescue StandardError => exception
          Failure("Error importing the work: #{exception.message}")
        end

        private

          # @param [Import::Work] import_work
          # @return [Array<Work::FileSet>]
          def saved_file_sets(import_work, file_set_hashes:)
            import_work.file_sets.map do |file_set|
              file_set_change_set = file_set_hashes.select { |hash| hash.identifier == file_set.id }.first
              resource = import_file_set(file_set, file_set_change_set: file_set_change_set)
              metadata_adapter.persister.save(resource: resource)
            end
          end

          # @param [Import::FileSet] file_set
          # @return [Work::FileSet]
          def import_file_set(file_set, file_set_change_set: nil)
            files = saved_files(file_set.files)
            if file_set_change_set.nil?
              ::Work::FileSet.new(
                member_ids: files.map(&:id),
                title: file_set.title,
                identifier: file_set.id
              )
            else
              resource = file_set_change_set.resource
              resource.member_ids = files.map(&:id)
              resource.identifier << file_set.id
              resource
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
