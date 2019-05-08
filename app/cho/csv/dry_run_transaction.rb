# frozen_string_literal: true

module Csv
  class DryRunTransaction
    include Dry::Transaction

    step :create_dry_run

    def create_dry_run(csv_dry_run:, path:, update:)
      result = csv_dry_run.new(path, update: update)
      Success(result)
    rescue StandardError => e
      Failure(e.message)
    end
  end
end
