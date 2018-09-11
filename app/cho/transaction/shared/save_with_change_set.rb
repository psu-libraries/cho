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
    end
  end
end
