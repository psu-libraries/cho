# frozen_string_literal: true

module Work
  module Import
    class CsvController < ApplicationController
      # GET /csv/create
      def create
        @csv_file = CsvFile.new
      end

      # GET /csv/update
      def update
        @csv_file = CsvFile.new
      end

      # POST /csv/validate
      def validate
        file = params[:work_import_csv_file][:file]
        @presenter = CsvDryRunResultsPresenter.new(CsvDryRun.new(file.path, update: update?))
        @file_name = file.path
        render :dry_run_results
      rescue CsvDryRun::InvalidCsvError => exception
        flash[:error] = exception.message
        redirect_to action: (update? ? :update : :create)
      end

      # POST /csv/import
      def import
        file_name = params[:file_name]
        dry_run =  CsvDryRun.new(file_name, update: update?)
        importer = CsvImporter.new(dry_run.results)
        if importer.run
          @created = importer.created
          render :import_success
        else
          @errors = importer.errors
          render :import_failure
        end
      end

      private

        def update?
          if params.key?(:update)
            params[:update] == 'true'
          else
            referring_path[:action] == 'update'
          end
        end

        # @return [Hash] with referring controller path and action
        # @example {:controller=>"work/import/csv", :action=>"update"}
        def referring_path
          return {} if request.referer.nil?

          Rails.application.routes.recognize_path(request.referer)
        end
    end
  end
end
