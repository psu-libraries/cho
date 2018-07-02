# frozen_string_literal: true

module Transaction
  module File
    class Update
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :validate, with: 'file.validate'
      step :save, with: 'file.save'
    end
  end
end
