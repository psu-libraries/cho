# frozen_string_literal: true

module Collection::ControllerBehaviors
  extend ActiveSupport::Concern
  include ValkyrieControllerBehaviors

  delegate :metadata_adapter, :storage_adapter, to: :change_set_persister
  delegate :persister, :query_service, to: :metadata_adapter

  # GET /collections/new
  def new
    @collection = initialize_change_set
  end

  # GET /collections/1/edit
  def edit
    @collection = load_change_set
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = change_set_class.new(resource_class.new)
    validate_save_and_respond(@collection, :new)
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    validate_save_and_respond(load_change_set, :edit)
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    change_set = change_set_class.new(find_resource(params[:id]))
    change_set_persister.buffer_into_index do |buffered_changeset_persister|
      buffered_changeset_persister.delete(resource: change_set)
    end
    flash[:alert] = "#{change_set.title.first} has been deleted"
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
      params.fetch(resource_class.model_name.param_key).to_unsafe_h
    end

    def find_resource(id)
      query_service.find_by(id: Valkyrie::ID.new(id))
    end

    def respond_success(change_set)
      redirect_to(polymorphic_path([:solr_document], id: change_set.resource.id))
    end

    def respond_error(change_set, error_view)
      @collection = change_set
      render error_view
    end
end
