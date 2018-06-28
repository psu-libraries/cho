# frozen_string_literal: true

require 'dry/transaction/operation'

module Transaction
  module Operations
    module File
      class Save
        include Dry::Transaction::Operation

        def call(change_set)
          saved_work_file = metadata_adapter.persister.save(resource: work_file(change_set))
          change_set.model.files << saved_work_file.id
          Success(change_set)
        rescue StandardError => e
          Failure("Error persisting file: #{e.message}")
        end

        private

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
