# frozen_string_literal: true

module Transaction
  module Operations
    module Shared
      class Validate
        include Dry::Transaction::Operation

        def call(change_set, additional_attributes: {})
          change_set.validate(additional_attributes)
          if change_set.valid?
            Success(change_set)
          else
            Failure(change_set)
          end
        end
      end
    end
  end
end
