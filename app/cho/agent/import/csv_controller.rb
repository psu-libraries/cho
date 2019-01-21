# frozen_string_literal: true

module Agent
  module Import
    class CsvController < ApplicationController
      include Csv::ControllerBehavior

      self.csv_presenter = Agent::Import::CsvDryRunResultsPresenter
      self.csv_dry_run = Agent::Import::CsvDryRun
    end
  end
end
