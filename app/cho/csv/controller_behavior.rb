# frozen_string_literal: true

module Csv::ControllerBehavior
  extend ActiveSupport::Concern

  included do
    class_attribute :csv_presenter, :csv_dry_run

    # @note Includes common csv views in the path of available templates
    def self._prefixes
      super + ['csv']
    end
  end

  # GET /csv/create
  def create
    @csv_file = Csv::File.new
  end

  # GET /csv/update
  alias :update :create

  # POST /csv/validate
  def validate
    file = params[:csv_file][:file]
    transaction_result = Csv::DryRunTransaction.new.call(csv_dry_run: csv_dry_run, path: file.path, update: update?)
    if transaction_result.success?
      @presenter = csv_presenter.new(transaction_result.success)
      @file_name = file.path
      render :dry_run_results
    else
      flash[:error] = transaction_result.failure
      redirect_to action: (update? ? :update : :create)
    end
  end

  # POST /csv/import
  def import
    if import_csv.success?
      @created = import_csv.success
      render :import_success
    else
      @errors = import_csv.failure
      render :import_failure
    end
  end

  private

    def import_csv
      @import_csv ||= Transaction::Operations::Import::Csv.new.call(
        csv_dry_run: csv_dry_run,
        file: params[:file_name],
        update: update?
      )
    end

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
