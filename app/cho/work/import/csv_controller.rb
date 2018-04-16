# frozen_string_literal: true

module Work
  module Import
    class CsvController < ApplicationController
      # GET /csv_file/new
      def new
        @csv_file = CsvFile.new
      end

      # POST /csv_file
      def create
        file = params[:work_import_csv_file][:file]
        @results = CsvDryRun.run(file.path)
        @file_name = file.path
        render :dry_run_results
      end

      def run_import
        file_name = params[:file_name]
        results =  CsvDryRun.run(file_name)
        importer = CsvImporter.new(results)
        if importer.run
          @created = importer.created
          render :import_success
        else
          @errors = importer.errors
          render :import_failure
        end
      end
    end
  end
end
