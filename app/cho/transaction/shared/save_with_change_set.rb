# frozen_string_literal: true

module Transaction
  module Shared
    class SaveWithChangeSet
      include Dry::Transaction(container: Operations::Container)

      # Operations will be resolved from the `Container` specified above
      step :validate, with: 'shared.validate'
      step :process_file
      step :import_work, with: 'import.work'
      step :save, with: 'shared.save'

      private

        def process_file(change_set)
          return Success(change_set) if change_set.try(:file).blank?

          mime_type = Mime::Type.lookup(change_set.file.content_type)
          if mime_type.symbol == :zip
            Operations::Import::Zip.new.call(change_set)
          else
            Operations::File::Save.new.call(change_set)
          end
        end
    end
  end
end
