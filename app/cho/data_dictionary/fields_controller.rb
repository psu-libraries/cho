# frozen_string_literal: true

module DataDictionary
  class FieldsController < ApplicationController
    include ValkyrieControllerBehaviors

    delegate :query_service, :persister, to: :change_set_persister

    # GET /data_dictionary_fields
    # GET /data_dictionary_fields.json
    def index
      @data_dictionary_fields = resource_class.all
    end

    # GET /data_dictionary_fields/1
    # GET /data_dictionary_fields/1.json
    def show
      @data_dictionary_field = find_resource(params[:id])
    end

    # GET /data_dictionary_fields/new
    def new
      @data_dictionary_field = initialize_change_set
    end

    # GET /data_dictionary_fields/1/edit
    def edit
      @data_dictionary_field = load_change_set
    end

    # POST /data_dictionary_fields
    # POST /data_dictionary_fields.json
    def create
      validate_save_and_respond(initialize_change_set, :new)
    end

    # PATCH/PUT /data_dictionary_fields/1
    # PATCH/PUT /data_dictionary_fields/1.json
    def update
      validate_save_and_respond(update_change_set, :edit)
    end

    # DELETE /data_dictionary_fields/1
    # DELETE /data_dictionary_fields/1.json
    def destroy
      persister.delete(resource: delete_change_set)
      respond_to do |format|
        format.html { redirect_to data_dictionary_fields_url, notice: 'Metadata field was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

      def respond_error(change_set, error_view)
        @data_dictionary_field = change_set
        respond_to do |format|
          format.html { render error_view }
          format.json { render json: change_set.errors, status: :unprocessable_entity }
        end
      end

      def respond_success(change_set)
        @data_dictionary_field = change_set
        respond_to do |format|
          format.html do
            redirect_to @data_dictionary_field.resource, notice: 'Metadata field was successfully updated.'
          end
          format.json { render :show, status: :ok, location: @data_dictionary_field.resource }
        end
      end

      def find_resource(id)
        query_service.find_by(id: Valkyrie::ID.new(id))
      end

      def update_change_set
        change_set_class.new(find_resource(params[:id]))
      end
      alias_method :delete_change_set, :update_change_set

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(metadata_adapter: Valkyrie::MetadataAdapter.find(:postgres),
                                                         storage_adapter: Valkyrie.config.storage_adapter)
      end

      def resource_params
        params[:data_dictionary_field].to_unsafe_h
      end

      def change_set_class
        FieldChangeSet
      end

      def resource_class
        DataDictionary::Field
      end
  end
end
