# frozen_string_literal: true

module Transaction::Operations::AccessControls
  class SystemCreator
    include Dry::Transaction::Operation

    def call(change_set)
      return Success(change_set) if change_set.persisted?

      updated_change_set = add_system_creator(change_set)
      Success(updated_change_set)
    rescue StandardError => e
      Failure(Transaction::Rejection.new('Error applying system creator', e))
    end

    def add_system_creator(change_set)
      return change_set unless change_set.try(:current_user)

      change_set.system_creator = change_set.current_user.login
      change_set
    end
  end
end
