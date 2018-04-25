# frozen_string_literal: true

module Work
  class SubmissionsController < ApplicationController
    include ValkyrieControllerBehaviors

    # GET /works/new
    def new
      work_type_id = params.fetch(:work_type_id, nil)
      if work_type_id
        @work = initialize_change_set(work_type_id: work_type_id)
      else
        flash[:alert] = 'You must specify a work type'
        redirect_to(root_path)
      end
    end

    # GET /works/1/edit
    def edit
      @work = load_change_set
    end

    # POST /works
    # POST /works.json
    def create
      validate_save_and_respond(change_set_class.new(resource_class.new), :new)
    end

    # PATCH/PUT /works/1
    # PATCH/PUT /works/1.json
    def update
      validate_save_and_respond(load_change_set, :edit)
    end

    private

      def respond_success(change_set)
        redirect_to(polymorphic_path([:solr_document], id: change_set.resource.id))
      end

      def respond_error(change_set, error_view)
        @work = change_set
        render error_view
      end

      def resource_params
        params[:work_submission].to_unsafe_h
      end

      def change_set_class
        SubmissionChangeSet
      end

      def resource_class
        Submission
      end
  end
end
