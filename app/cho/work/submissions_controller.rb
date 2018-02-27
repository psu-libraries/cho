# frozen_string_literal: true

module Work
  class SubmissionsController < ApplicationController
    include ValkyrieControllerBehaviors

    delegate :metadata_adapter, :storage_adapter, to: :change_set_persister
    delegate :persister, :query_service, to: :metadata_adapter

    # GET /works/new
    def new
      work_type = params.fetch(:work_type, nil)
      if work_type
        @work = Work::Form.new(initialize_change_set(work_type: work_type))
      else
        flash[:alert] = 'You must specify a work type'
        redirect_to(root_path)
      end
    end

    # GET /works/1/edit
    def edit
      @work = Work::Form.new(load_change_set)
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

    # DELETE /works/1
    # DELETE /works/1.json
    def destroy
      change_set = change_set_class.new(find_resource(params[:id]))
      change_set_persister.buffer_into_index do |buffered_changeset_persister|
        buffered_changeset_persister.delete(resource: change_set)
      end
      flash[:alert] = "#{change_set.title.first} has been deleted"
      redirect_to(root_path)
    end

    private

      def respond_success(change_set)
        redirect_to(polymorphic_path([:solr_document], id: change_set.resource.id))
      end

      def respond_error(change_set, error_view)
        @work = Work::Form.new(change_set)
        render error_view
      end

      def find_resource(id)
        query_service.find_by(id: Valkyrie::ID.new(id))
      end

      def resource_params
        params[:work_submission].to_unsafe_h
      end

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(
          metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
          storage_adapter: Valkyrie.config.storage_adapter
        )
      end

      def change_set_class
        SubmissionChangeSet
      end

      def resource_class
        Submission
      end
  end
end
