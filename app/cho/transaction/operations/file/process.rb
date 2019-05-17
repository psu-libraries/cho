# frozen_string_literal: true

module Transaction
  module Operations
    module File
      class Process
        include Dry::Transaction::Operation

        def call(change_set)
          return Success(change_set) if change_set.try(:file).blank?

          mime_type = Mime::Type.lookup(change_set.file.content_type)
          if mime_type.symbol == :zip
            Operations::Import::Zip.new.call(change_set)
          else
            Operations::File::Save.new.call(change_set)
          end
        rescue StandardError => e
          Failure(Transaction::Rejection.new('Error processing file', e))
        end
      end
    end
  end
end
