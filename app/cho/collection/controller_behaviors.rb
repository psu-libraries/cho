# frozen_string_literal: true

module Collection::ControllerBehaviors
  extend ActiveSupport::Concern
  include ValkyrieControllerBehaviors

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

  private

    def resource_params
      params.fetch(resource_class.model_name.param_key).to_unsafe_h
    end

    def respond_success(change_set)
      redirect_to(polymorphic_path([:solr_document], id: change_set.resource.id))
    end

    def respond_error(change_set, error_view)
      @collection = change_set
      render error_view
    end
end
