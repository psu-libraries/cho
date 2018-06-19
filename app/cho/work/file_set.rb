# frozen_string_literal: true

# A primary resource type in CHO, a file set contains other File resources each of which relates
# to a single original binary source.
# File sets are indexed both in Solr and and Postgres using the {IndexingAdapter}.
class Work::FileSet < Valkyrie::Resource
  include CommonQueries
  include DataDictionary::FieldsForObject

  attribute :id, Valkyrie::Types::ID.optional
  attribute :member_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID)
end
