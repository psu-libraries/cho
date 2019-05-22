# frozen_string_literal: true

module Transaction
  module Operations
    module Shared
      class ApplyAccessLevel
        include Dry::Transaction::Operation

        def call(change_set)
          return Success(change_set) if change_set.try(:access_level).blank?
          return Failure(change_set) unless change_set.valid?

          change_set.resource.read_groups += [change_set.access_level]
          Success(change_set)
        rescue StandardError => e
          Failure(Transaction::Rejection.new('Error applying access level', e))
        end
      end
    end
  end
end
