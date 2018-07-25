# frozen_string_literal: true

module Transaction
  module Shared
    class SaveWithChangeSet
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :validate, with: 'shared.validate'
      step :save_file, with: 'file.save'
      step :import_work, with: 'import.work'
      step :save, with: 'shared.save'

      def save_file(change_set)
        result = Transaction::Operations::File::Validate.new.call(change_set)
        return Success(change_set) if result.failure?

        super(change_set)
      end
    end
  end
end
