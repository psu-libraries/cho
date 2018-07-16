# frozen_string_literal: true

module Transaction
  module Operations
    module File
      class Validate
        include Dry::Transaction::Operation

        # @note We return a failure if the change set doesn't support files or doesn't contain
        #  any files to save. It's unclear whether this is a correct usage for a transactions,
        #  and if failures should be reserved only for exceptions. An alternative could be to
        #  move the guard clause to File::Save, but it seems to make sense to have it here as
        #  a validation.
        def call(change_set)
          return Failure(change_set) unless change_set.respond_to?(:file) && change_set.file.present?
          Success(change_set)
        rescue StandardError => e
          Failure("Error validating file: #{e.message}")
        end
      end
    end
  end
end
