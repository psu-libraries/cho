# frozen_string_literal: true

# An internal CHO resource used for defining the kinds {Schema::MetadataField} resources assigned
# to a {Work::Submission}.
# Work types are not indexed in Solr and are only persisted in Postgres via the {Postgres::SingularMetadataAdapter}.
module Work
  class Type < Valkyrie::Resource
    include CommonQueries

    attribute :label, Valkyrie::Types::String
    attribute :metadata_schema_id, Valkyrie::Types::ID.optional
    attribute :processing_schema, Valkyrie::Types::String
    attribute :display_schema, Valkyrie::Types::String

    def metadata_schema
      @metadata_schema ||= Schema::Metadata.find(metadata_schema_id)
    end
  end
end
