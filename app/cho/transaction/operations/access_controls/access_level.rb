# frozen_string_literal: true

module Transaction::Operations::AccessControls
  class AccessLevel
    include Dry::Transaction::Operation

    def call(change_set)
      return Success(change_set) if change_set.try(:access_level).blank?

      remaining_groups = change_set.read_groups - Repository::AccessLevel.names
      change_set.read_groups = (remaining_groups | [change_set.access_level])
      Success(change_set)
    rescue StandardError => e
      Failure(Transaction::Rejection.new('Error applying access level', e))
    end
  end
end
