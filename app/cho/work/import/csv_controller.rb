# frozen_string_literal: true

module Work
  module Import
    class CsvController < ApplicationController
      include Csv::ControllerBehavior

      self.csv_presenter = Work::Import::CsvDryRunResultsPresenter
      self.csv_dry_run = Work::Import::CsvDryRun
    end
  end
end
