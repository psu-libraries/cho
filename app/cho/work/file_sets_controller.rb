# frozen_string_literal: true

module Work
  class FileSetsController < ApplicationController
    include ValkyrieControllerBehaviors

    # GET /file_sets/1/edit
    def edit
      @file_set = load_change_set
    end

    # PATCH/PUT /file_sets/1
    # PATCH/PUT /file_sets/1.json
    def update
      validate_save_and_respond(load_change_set, :edit)
    end

    private

      def respond_success(change_set)
        redirect_to(polymorphic_path([:solr_document], id: change_set.resource.id))
      end

      def respond_error(change_set, error_view)
        change_set.sync
        @file_set = change_set
        render error_view
      end

      def resource_params
        params[:work_file_set].to_unsafe_h
      end

      def change_set_class
        FileSetChangeSet
      end

      def resource_class
        FileSet
      end
  end
end
