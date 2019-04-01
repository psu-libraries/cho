# frozen_string_literal: true

module Csv
  class DryRunTransaction
    include Dry::Transaction

    step :create_dry_run

    def create_dry_run(csv_dry_run:, path:, update:)
      result = csv_dry_run.new(path, update: update)
      return Success(result)
    rescue StandardError => error
      return Failure(error.message)
    end
  end
end
