# frozen_string_literal: true

module Transaction
  module Shared
    class SaveWithResource
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :create, with: 'change_set.create'
      step :validate, with: 'change_set.validate'
      step :save_file, with: 'file.save'
      step :save, with: 'change_set.save'
    end
  end
end
