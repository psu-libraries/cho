# frozen_string_literal: true

module Transaction
  module File
    class Delete
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :delete, with: 'file.delete'
    end
  end
end
