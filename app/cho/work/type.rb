# frozen_string_literal: true

module Work
  class Type < Valkyrie::Resource
    include Valkyrie::Resource::AccessControls
    include CommonQueries

    attribute :id, Valkyrie::Types::ID.optional
    attribute :label, Valkyrie::Types::String
    attribute :metadata_schema_id, Valkyrie::Types::ID.optional
    attribute :processing_schema, Valkyrie::Types::String
    attribute :display_schema, Valkyrie::Types::String

    def metadata_schema
      @metadata_schema ||= Schema::Metadata.find(metadata_schema_id)
    end
  end
end
