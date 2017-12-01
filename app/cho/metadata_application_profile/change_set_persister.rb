# frozen_string_literal: true

# A basic change set persister that will save to a metadata and storage adapter, but will not
# index anything to Solr at the same time. If you want to index into Solr as well as save
# to the metadata adapter, see {ChangeSetPersister}.
# @todo This could be moved or combined with ChangeSetPersister in the Valkyrie folder.
module MetadataApplicationProfile
  class ChangeSetPersister
    attr_reader :metadata_adapter, :storage_adapter
    delegate :persister, :query_service, to: :metadata_adapter

    def initialize(metadata_adapter:, storage_adapter:)
      @metadata_adapter = metadata_adapter
      @storage_adapter = storage_adapter
    end

    def save(change_set:)
      persister.save(resource: change_set.resource)
    rescue StandardError => e
      change_set.errors.add(:save, e.message)
      change_set
    end

    def delete(change_set:)
      persister.delete(resource: change_set.resource)
    rescue StandardError => e
      change_set.errors.add(:delete, e.message)
      change_set
    end

    def save_all(change_sets:)
      change_sets.map do |change_set|
        save(change_set: change_set)
      end
    end
  end
end
