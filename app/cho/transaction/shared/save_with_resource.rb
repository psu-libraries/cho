# frozen_string_literal: true

module Transaction
  module Shared
    class SaveWithResource
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :create_change_set, with: 'shared.create_change_set'
      step :validate, with: 'shared.validate'
      step :save_file, with: 'file.save'
      step :save, with: 'shared.save'

      def save_file(change_set)
        result = Transaction::Operations::File::Validate.new.call(change_set)
        return Success(change_set) if result.failure?

        super(change_set)
      end
    end
  end
end
