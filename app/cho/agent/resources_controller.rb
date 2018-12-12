# frozen_string_literal: true

module Agent
  class ResourcesController < ApplicationController
    include ValkyrieControllerBehaviors

    delegate :query_service, :persister, to: :change_set_persister

    # GET /agents
    # GET /agents.json
    def index
      @agents = resource_class.all
    end

    # GET /agents/1
    # GET /agents/1.json
    def show
      @agent = find_resource(params[:id])
    end

    # GET /agents/new
    def new
      @agent = initialize_change_set
    end

    # GET /agents/1/edit
    def edit
      @agent = load_change_set
    end

    # POST /agents
    # POST /agents.json
    def create
      validate_save_and_respond(initialize_change_set, :new)
    end

    # PATCH/PUT /agents/1
    # PATCH/PUT /agents/1.json
    def update
      validate_save_and_respond(update_change_set, :edit)
    end

    # DELETE /agents/1
    # DELETE /agents/1.json
    def destroy
      destroy_item(agent_resources_url, 'Agent was successfully destroyed.')
    end

    private

      def find_resource(id)
        query_service.find_by(id: Valkyrie::ID.new(id))
      end

      def update_change_set
        change_set_class.new(find_resource(params[:id]))
      end
      alias_method :delete_change_set, :update_change_set

      def resource_params
        params[:agent].to_unsafe_h
      end

      def change_set_class
        ChangeSet
      end

      def resource_class
        Resource
      end

      def view_data(change_set)
        @agent = change_set
      end

      def success_message
        'Agent was successfully updated.'
      end
  end
end
