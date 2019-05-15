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
          change_set.errors.add(:apply_access_level, e.message)
          Failure(change_set)
        end
      end
    end
  end
end
