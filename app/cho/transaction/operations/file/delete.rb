# frozen_string_literal: true

require 'dry/transaction/operation'

module Transaction
  module Operations
    module File
      class Delete
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
