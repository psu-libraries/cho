# frozen_string_literal: true

module Transaction::Operations::ChangeSet
  class Validate
    include Dry::Transaction::Operation

    def call(change_set, additional_attributes: {})
      change_set.validate(additional_attributes)
      if change_set.valid?
        Success(change_set)
      else
        Failure(change_set)
      end
    rescue StandardError => e
      Failure(Transaction::Rejection.new('Error validating changeset', e))
    end
  end
end
