# frozen_string_literal: true

require 'dry/transaction/operation'

module Transaction
  module Operations
    module File
      class CreateTempFile
        include Dry::Transaction::Operation

        def call(io)
          temp_file = Tempfile.new('cho_temp_file')
          updated_temp_file = write_file(temp_file: temp_file, io: io)
          Success(updated_temp_file)
        rescue StandardError => e
          Failure(Transaction::Rejection.new("Error persisting file: #{e.message}"))
        end

        private

          def write_file(temp_file:, io:)
            until io.eof?
              chunk = io.read 1024
              temp_file.write chunk
            end
            temp_file.rewind
            temp_file
          end
      end
    end
  end
end
