# frozen_string_literal: true

require 'dry/transaction/operation'

module Transaction
  module Operations
    module Import
      class Csv
        include Dry::Transaction::Operation

        def call(csv_dry_run:, file:, update:, current_user: nil)
          dry_run = csv_dry_run.new(file, update: update)
          importer = ::Csv::Importer.new(change_set_list: dry_run.results, current_user: current_user)
          importer.run
          delete_bag(dry_run)

          if importer.errors.present?
            Failure(importer.errors)
          else
            Success(importer.created)
          end
        rescue StandardError => e
          Failure(Array.wrap(e.message))
        end

        private

          def delete_bag(dry_run)
            return unless dry_run.bag.success?

            FileUtils.rm_rf(dry_run.bag.success.path)
          end
      end
    end
  end
end
