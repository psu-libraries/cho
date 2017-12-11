# frozen_string_literal: true

module DataDictionary
  class FieldsController < ApplicationController
    delegate :query_service, :persister, to: :change_set_persister

    # GET /data_dictionary_fields
    # GET /data_dictionary_fields.json
    def index
      @data_dictionary_fields = DataDictionary::Field.all
    end

    # GET /data_dictionary_fields/1
    # GET /data_dictionary_fields/1.json
    def show
      @data_dictionary_field = find_resource(params[:id])
    end

    # GET /data_dictionary_fields/new
    def new
      @data_dictionary_field = FieldChangeSet.new(DataDictionary::Field.new).prepopulate!
    end

    # GET /data_dictionary_fields/1/edit
    def edit
      @data_dictionary_field = FieldChangeSet.new(find_resource(params[:id])).prepopulate!
    end

    # POST /data_dictionary_fields
    # POST /data_dictionary_fields.json
    def create
      @data_dictionary_field = persist_changes(create_change_set)
      respond_to do |format|
        if @data_dictionary_field.respond_to?(:errors)
          format.html { render :edit }
          format.json { render json: @data_dictionary_field.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to @data_dictionary_field, notice: 'Metadata field was successfully created.' }
          format.json { render :show, status: :created, location: data_dictionary_field }
        end
      end
    end

    # PATCH/PUT /data_dictionary_fields/1
    # PATCH/PUT /data_dictionary_fields/1.json
    def update
      @data_dictionary_field = persist_changes(update_change_set)
      respond_to do |format|
        if @data_dictionary_field.respond_to?(:errors)
          format.html { render :edit }
          format.json { render json: @data_dictionary_field.errors, status: :unprocessable_entity }
        else
          format.html { redirect_to @data_dictionary_field, notice: 'Metadata field was successfully updated.' }
          format.json { render :show, status: :ok, location: data_dictionary_field }
        end
      end
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

      def find_resource(id)
        query_service.find_by(id: Valkyrie::ID.new(id))
      end

      def update_change_set
        FieldChangeSet.new(find_resource(params[:id]))
      end
      alias_method :delete_change_set, :update_change_set

      def create_change_set
        FieldChangeSet.new(Field.new).prepopulate!
      end

      # @return [Field, FieldChangeSet]
      # @note
      #   This returns two kinds of objects. If both validation and saving are successful,
      #   then a Field resource is returned. Otherwise, the change set is returned with errors.
      # @see https://github.com/psu-libraries/cho/issues/298
      def persist_changes(change_set)
        return change_set unless change_set.validate(resource_params)
        change_set.sync
        persister.save(resource: change_set)
      end

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(metadata_adapter: Valkyrie::MetadataAdapter.find(:postgres),
                                                         storage_adapter: Valkyrie.config.storage_adapter)
      end

      def resource_params
        params[:data_dictionary_field].to_unsafe_h
      end
  end
end
