# frozen_string_literal: true

module Transaction
  module Shared
    class SaveWithChangeSet
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :validate, with: 'shared.validate'
      step :process_file, with: 'file.process'
      step :import_work, with: 'import.work'
      step :access_level, with: 'access_controls.access_level'
      step :system_creator, with: 'access_controls.system_creator'
      step :permissions, with: 'access_controls.permissions'
      step :save, with: 'shared.save'
    end
  end
end
