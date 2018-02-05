# frozen_string_literal: true

require 'valkyrie'
Rails.application.config.to_prepare do
  # Metadata Adapters

  Valkyrie::MetadataAdapter.register(
    Valkyrie::Persistence::Postgres::MetadataAdapter.new,
    :postgres
  )

  Valkyrie::MetadataAdapter.register(
    Valkyrie::Persistence::Memory::MetadataAdapter.new,
    :memory
  )

  # Valkyrie::MetadataAdapter.register(
  #   Valkyrie::Persistence::Solr::MetadataAdapter.new(connection: Blacklight.default_index.connection,
  #                                                    resource_indexer: Valkyrie::Indexers::AccessControlsIndexer),
  #   :index_solr
  # )

  Valkyrie::MetadataAdapter.register(
    Valkyrie::Persistence::Solr::MetadataAdapter.new(
      connection: Blacklight.default_index.connection,
      resource_indexer: Valkyrie::Persistence::Solr::CompositeIndexer.new(
        Valkyrie::Indexers::AccessControlsIndexer,
        Work::SubmissionIndexer
      )
    ),
    :index_solr
  )

  Valkyrie::MetadataAdapter.register(
    IndexingAdapter.new(
      metadata_adapter: Valkyrie.config.metadata_adapter,
      index_adapter: Valkyrie::MetadataAdapter.find(:index_solr)
    ),
    :indexing_persister
  )

  # Storage Adapters

  Valkyrie::StorageAdapter.register(
    Valkyrie::Storage::Disk.new(base_path: Rails.root.join('tmp', 'files')),
    :disk
  )

  Valkyrie::StorageAdapter.register(
    Valkyrie::Storage::Memory.new,
    :memory
  )

  # Queries

  Valkyrie.config.metadata_adapter.query_service.custom_queries.register_query_handler(FindUsing)
  Valkyrie.config.metadata_adapter.query_service.custom_queries.register_query_handler(FindModel)
end
