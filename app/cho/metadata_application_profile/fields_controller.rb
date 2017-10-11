# frozen_string_literal: true

module MetadataApplicationProfile
  class FieldsController < ApplicationController
    before_action :set_metadata_field, only: [:show, :edit, :update, :destroy]

    # GET /metadata_application_profile_fields
    # GET /metadata_application_profile_fields.json
    def index
      @metadata_application_profile_fields = MetadataApplicationProfile::Field.all
    end

    # GET /metadata_application_profile_fields/1
    # GET /metadata_application_profile_fields/1.json
    def show; end

    # GET /metadata_application_profile_fields/new
    def new
      @metadata_application_profile_field = MetadataApplicationProfile::Field.new
    end

    # GET /metadata_application_profile_fields/1/edit
    def edit; end

    # POST /metadata_application_profile_fields
    # POST /metadata_application_profile_fields.json
    def create
      no_error = false
      begin
        metadata_application_profile_field = MetadataApplicationProfile::Field.new(metadata_field_params)
        no_error = metadata_application_profile_field.save
      rescue ArgumentError => e
        no_error = false
        metadata_application_profile_field = MetadataApplicationProfile::Field.new
        metadata_application_profile_field.errors.add('Invalid argument', e.message)
      end

      respond_to do |format|
        if no_error
          format.html { redirect_to metadata_application_profile_field, notice: 'Metadata field was successfully created.' }
          format.json { render :show, status: :created, location: metadata_application_profile_field }
        else
          format.html { render :new }
          format.json { render json: metadata_application_profile_field.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /metadata_application_profile_fields/1
    # PATCH/PUT /metadata_application_profile_fields/1.json
    def update
      no_error = false
      begin
        @metadata_application_profile_field.update(metadata_field_params)
        no_error = @metadata_application_profile_field.save
      rescue ArgumentError => e
        no_error = false
        @metadata_application_profile_field.errors.add('Invalid argument', e.message)
      end

      respond_to do |format|
        if no_error
          format.html { redirect_to @metadata_application_profile_field, notice: 'Metadata field was successfully updated.' }
          format.json { render :show, status: :ok, location: metadata_application_profile_field }
        else
          format.html { render :edit }
          format.json { render json: @metadata_application_profile_field.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /metadata_application_profile_fields/1
    # DELETE /metadata_application_profile_fields/1.json
    def destroy
      @metadata_application_profile_field.destroy
      respond_to do |format|
        format.html { redirect_to metadata_application_profile_fields_url, notice: 'Metadata field was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_metadata_field
        @metadata_application_profile_field = MetadataApplicationProfile::Field.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def metadata_field_params
        params.require(:metadata_application_profile_field).permit(:label, :field_type, :requirement_designation, :validation, :multiple, :controlled_vocabulary, :default_value, :display_name, :display_transformation)
      end
  end
end
