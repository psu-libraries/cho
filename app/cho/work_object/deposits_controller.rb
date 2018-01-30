# frozen_string_literal: true

module WorkObject
  class DepositsController < ApplicationController
    delegate :metadata_adapter, :storage_adapter, to: :change_set_persister
    delegate :persister, :query_service, to: :metadata_adapter

    # GET /work_objects/new
    def new
      @work = ChangeSet.new(WorkObject::Deposit.new).prepopulate!
    end

    # GET /work_objects/1/edit
    def edit
      @work = ChangeSet.new(find_resource(params[:id])).prepopulate!
    end

    # POST /work_objects
    # POST /work_objects.json
    def create
      @work = ChangeSet.new(WorkObject::Deposit.new)
      if @work.validate(resource_params)
        @work.sync
        obj = nil
        change_set_persister.buffer_into_index do |buffered_changeset_persister|
          obj = buffered_changeset_persister.save(resource: @work)
        end
        redirect_to(polymorphic_path([:solr_document], id: obj.id))
      else
        render :new
      end
    end

    # PATCH/PUT /work_objects/1
    # PATCH/PUT /work_objects/1.json
    def update
      @work = ChangeSet.new(find_resource(params[:id])).prepopulate!
      if @work.validate(resource_params)
        @work.sync
        obj = nil
        change_set_persister.buffer_into_index do |buffered_changeset_persister|
          obj = buffered_changeset_persister.save(resource: @work)
        end
        redirect_to(polymorphic_path([:solr_document], id: obj.id))
      else
        render :edit
      end
    end

    # DELETE /work_objects/1
    # DELETE /work_objects/1.json
    def destroy
      change_set = ChangeSet.new(find_resource(params[:id]))
      change_set_persister.buffer_into_index do |buffered_changeset_persister|
        buffered_changeset_persister.delete(resource: change_set)
      end
      flash[:alert] = "#{change_set.title.first} has been deleted"
      redirect_to(root_path)
    end

    private

      # Never trust parameters from the scary internet, only allow the white list through.
      def work_params
        params.fetch(:work_object, {})
      end

      def find_resource(id)
        query_service.find_by(id: Valkyrie::ID.new(id))
      end

      def resource_params
        params[:work_object_deposit].to_unsafe_h
      end

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(
          metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
          storage_adapter: Valkyrie.config.storage_adapter
        )
      end
  end
end
