# frozen_string_literal: true

module Transaction::Operations::AccessControls
  class Permissions
    include Dry::Transaction::Operation

    # @return [Valkyrie::ChangeSet]
    # @note duplicate members can be removed by the underlying resource model
    def call(change_set)
      return Success(change_set) unless
        change_set.class.ancestors.include?(Repository::AccessControls::ChangeSetBehaviors)

      change_set.read_users |= [change_set.system_creator]
      Success(change_set)
    rescue StandardError => e
      Failure(Transaction::Rejection.new('Error applying permissions', e))
    end
  end
end
