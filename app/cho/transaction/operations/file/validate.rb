# frozen_string_literal: true

module Transaction
  module Operations
    module File
      class Validate
        include Dry::Transaction::Operation

        def call(file)
          Success(file)
        rescue StandardError
          Failure('error persisting file')
        end
      end
    end
  end
end
