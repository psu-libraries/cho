# frozen_string_literal: true

module Transaction::Operations::AccessControls
  class AccessLevel
    include Dry::Transaction::Operation

    # @note the function of this transaction is completely dependent on the :access_rights data dictionary
    # term. If that term is not present in the data dictionary, and is not defined on the resources we
    # want to govern with these rights, this function will not work.
    def call(change_set)
      return Success(change_set) if change_set.try(:access_rights).blank?

      remaining_groups = change_set.read_groups - Repository::AccessLevel.names
      change_set.read_groups = (remaining_groups | Array.wrap(change_set.access_rights))
      Success(change_set)
    rescue StandardError => e
      Failure(Transaction::Rejection.new('Error applying access level', e))
    end
  end
end
