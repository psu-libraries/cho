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
    end
  end
end
