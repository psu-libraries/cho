# frozen_string_literal: true

module Transaction
  module Operations
    module Import
      class Zip
        include Dry::Transaction::Operation

        def call(change_set)
          bag = Transaction::Import::ImportFromZip.new.call(
            zip_name: Pathname.new(change_set.file.original_filename).basename('.zip').to_s,
            zip_path: change_set.file.path
          )
          return Failure(change_set) if bag.failure?
          return Failure('Cannot import bags with more that one work') if bag.success.works.count > 1

          change_set.import_work = bag.success.works.first
          Success(change_set)
        rescue StandardError => e
          Failure(Transaction::Rejection.new('Unable to import zip file from the GUI', e))
        end
      end
    end
  end
end
