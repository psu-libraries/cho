# frozen_string_literal: true

module Transaction
  module Import
    class ImportFromZip
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :extract, with: 'import.extract'
      step :validate, with: 'import.validate'
    end
  end
end
