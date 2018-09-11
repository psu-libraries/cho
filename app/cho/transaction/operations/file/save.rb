# frozen_string_literal: true

module Transaction
  module Operations
    module File
      class Save
        include Dry::Transaction::Operation

        # @note If the change_set does not support files, it returns Success so that any other
        #   workflow steps may proceed.
        def call(change_set)
          return Success(change_set) unless change_set.respond_to?(:file) && change_set.file.present?
          saved_work_file_set = metadata_adapter.persister.save(resource: work_file_set(change_set))
          change_set.model.file_set_ids << saved_work_file_set.id
          Success(change_set)
        rescue StandardError => e
          Failure("Error persisting file: #{e.message}")
        end

        private

          def work_file_set(change_set)
            file = metadata_adapter.persister.save(resource: work_file(change_set))
            Work::FileSet.new(member_ids: [file.id], title: change_set.file.original_filename)
          end

          def work_file(change_set)
            Work::File.new(
              file_identifier: adapter_file(change_set).id,
              original_filename: change_set.file.original_filename
            )
          end

          def adapter_file(change_set)
            storage_adapter.upload(
              file: change_set.file.tempfile,
              original_filename: change_set.file.original_filename,
              resource: change_set.model
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
