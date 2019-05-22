# frozen_string_literal: true

# A primary resource type in CHO, a collection contains other {Work::Submission} resources.
# Collections are indexed both in Solr and and Postgres using the {IndexingAdapter}.
module Collection
  class Library < Valkyrie::Resource
    include Repository::Access::ResourceControls
    include CommonFields
    include CommonQueries
    include WithMembers

    def self.model_name
      ActiveModel::Name.new(self, nil, 'library_collection')
    end
  end
end
