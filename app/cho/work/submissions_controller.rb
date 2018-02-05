# frozen_string_literal: true

module Work
  class SubmissionsController < ApplicationController
    delegate :metadata_adapter, :storage_adapter, to: :change_set_persister
    delegate :persister, :query_service, to: :metadata_adapter

    # GET /works/new
    def new
      @work = SubmissionChangeSet.new(Submission.new).prepopulate!
    end

    # GET /works/1/edit
    def edit
      @work = SubmissionChangeSet.new(find_resource(params[:id])).prepopulate!
    end

    # POST /works
    # POST /works.json
    def create
      validate_save_and_render(SubmissionChangeSet.new(Submission.new), :new)
    end

    # PATCH/PUT /works/1
    # PATCH/PUT /works/1.json
    def update
      validate_save_and_render(SubmissionChangeSet.new(find_resource(params[:id])).prepopulate!, :edit)
    end

    # DELETE /works/1
    # DELETE /works/1.json
    def destroy
      change_set = SubmissionChangeSet.new(find_resource(params[:id]))
      change_set_persister.buffer_into_index do |buffered_changeset_persister|
        buffered_changeset_persister.delete(resource: change_set)
      end
      flash[:alert] = "#{change_set.title.first} has been deleted"
      redirect_to(root_path)
    end

    private

      def validate_save_and_render(change_set, error_view)
        if change_set.validate(resource_params)
          change_set.sync
          obj = nil
          change_set_persister.buffer_into_index do |buffered_changeset_persister|
            obj = buffered_changeset_persister.save(resource: change_set)
          end
          redirect_to(polymorphic_path([:solr_document], id: obj.id))
        else
          @work = change_set
          render error_view
        end
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
  end
end
