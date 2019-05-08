# frozen_string_literal: true

require 'dry/transaction/operation'

module Transaction
  module Operations
    module File
      class Create
        include Dry::Transaction::Operation

        def call(file_change_set, temp_file:)
          saved_work_file = metadata_adapter.persister.save(resource: work_file(file_change_set, temp_file: temp_file))
          Success(file_change_set.class.new(saved_work_file))
        rescue StandardError => e
          Failure(Transaction::Rejection.new("Error persisting file: #{e.message}"))
        end

        private

          def work_file(file_change_set, temp_file:)
            file_change_set.file_identifier = adapter_file(file_change_set, temp_file: temp_file).id
            file_change_set.sync
            file_change_set.model
          end

          def adapter_file(file_change_set, temp_file:)
            storage_adapter.upload(
              file: temp_file,
              original_filename: file_change_set.original_filename,
              resource: file_change_set.model
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
