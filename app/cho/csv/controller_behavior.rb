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
    @presenter = csv_presenter.new(csv_dry_run.new(file.path, update: update?))
    @file_name = file.path
    render :dry_run_results
  rescue Csv::ValidationError => exception
    flash[:error] = exception.message
    redirect_to action: (update? ? :update : :create)
  end

  # POST /csv/import
  def import
    file_name = params[:file_name]
    dry_run =  csv_dry_run.new(file_name, update: update?)
    importer = Csv::Importer.new(dry_run.results)
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
