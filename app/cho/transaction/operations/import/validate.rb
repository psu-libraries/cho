# frozen_string_literal: true

require 'dry/transaction/operation'

module Transaction
  module Operations
    module Import
      class Validate
        include Dry::Transaction::Operation

        # @param [Pathname] bag_path
        def call(bag_path)
          bag = ::Import::Bag.new(bag_path)
          return Success(bag) if bag.valid?

          Failure(bag)
        rescue StandardError => exception
          Failure(Transaction::Rejection.new("Error validating the bag: #{exception.message}"))
        end
      end
    end
  end
end
