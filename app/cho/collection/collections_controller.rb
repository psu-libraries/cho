# frozen_string_literal: true

class CollectionsController < ApplicationController
  delegate :metadata_adapter, :storage_adapter, to: :change_set_persister
  delegate :persister, :query_service, to: :metadata_adapter

  # GET /collections/new
  def new
    @collection = CollectionChangeSet.new(Collection.new).prepopulate!
  end

  # GET /collections/1/edit
  def edit
    @collection = CollectionChangeSet.new(find_resource(params[:id])).prepopulate!
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = CollectionChangeSet.new(Collection.new)
    if @collection.validate(resource_params)
      @collection.sync
      obj = nil
      change_set_persister.buffer_into_index do |buffered_changeset_persister|
        obj = buffered_changeset_persister.save(resource: @collection)
      end
      redirect_to(polymorphic_path([:solr_document], id: obj.id))
    else
      render :new
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    @collection = CollectionChangeSet.new(find_resource(params[:id])).prepopulate!
    if @collection.validate(resource_params)
      @collection.sync
      obj = nil
      change_set_persister.buffer_into_index do |buffered_changeset_persister|
        obj = buffered_changeset_persister.save(resource: @collection)
      end
      redirect_to(polymorphic_path([:solr_document], id: obj.id))
    else
      render :edit
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    change_set = CollectionChangeSet.new(find_resource(params[:id]))
    change_set_persister.buffer_into_index do |buffered_changeset_persister|
      buffered_changeset_persister.delete(resource: change_set)
    end
    flash[:alert] = "#{change_set.title} has been deleted"
    redirect_to(root_path)
  end

  private

    def change_set_persister
      @change_set_persister ||= ChangeSetPersister.new(
        metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
        storage_adapter: Valkyrie.config.storage_adapter
      )
    end

    def resource_params
      params[Collection.to_s.underscore.to_sym].to_unsafe_h
    end

    def find_resource(id)
      query_service.find_by(id: Valkyrie::ID.new(id))
    end
end
