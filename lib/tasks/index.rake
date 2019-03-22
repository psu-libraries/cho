# frozen_string_literal: true

namespace :cho do
  namespace :index do
    desc 'Batch load works from a directory of csv files'
    task reindex_all: :environment do
      postgres_adapter = Valkyrie::MetadataAdapter.find(:postgres)
      solr_adapter = Valkyrie::MetadataAdapter.find(:index_solr)
      postgres_query_serice = postgres_adapter.query_service
      solr_persister = solr_adapter.persister
      index_all(query_service: postgres_query_serice, persister: solr_persister, model: Collection::Archival)
      index_all(query_service: postgres_query_serice, persister: solr_persister, model: Collection::Library)
      index_all(query_service: postgres_query_serice, persister: solr_persister, model: Collection::Curated)
      index_all(query_service: postgres_query_serice, persister: solr_persister, model: Work::Submission)
      index_all(query_service: postgres_query_serice, persister: solr_persister, model: Work::FileSet)
    end

    def index_all(query_service:, persister:, model:, slice: 1000)
      resources = []
      query_service.find_all_of_model(model: model).each do |resource|
        resources << resource
        if resources.count == slice
          persister.save_all(resources: items)
          resources = []
        end
      end
      persister.save_all(resources: resources) if resources.count.positive?
    end
  end
end
