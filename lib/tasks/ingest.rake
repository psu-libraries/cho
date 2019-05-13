# frozen_string_literal: true

namespace :cho do
  namespace :ingest do
    desc 'Batch load works from a directory of csv files'
    task works: :environment do
      Pathname.glob(Cho::Application.config.network_ingest_directory.join('*.csv')).each do |csv_file|
        print "Importing works from #{csv_file.basename} ... "

        reader = Work::Import::CsvReader.new(File.open(csv_file))
        collection_id = reader.csv_hashes.map { |hash| hash.fetch('home_collection_id', nil) }.compact.first
        create_collection(collection_id)

        result = Transaction::Operations::Import::Csv.new.call(
          csv_dry_run: Work::Import::CsvDryRun,
          file: csv_file,
          update: false
        )

        if result.success?
          puts 'Success!'
        else
          puts result.failure
        end
      end
    end

    def create_collection(id)
      return if collection_exists?(id)

      collection = Collection::Archival.new(
        title: "Collection for #{id}",
        alternate_ids: [id],
        access_level: 'public',
        workflow: 'default'
      )
      change_set_persister.persister.save(resource: collection)
    end

    def collection_exists?(id)
      change_set_persister.query_service.find_by_alternate_identifier(alternate_identifier: id)
      true
    rescue Valkyrie::Persistence::ObjectNotFoundError
      false
    end

    def change_set_persister
      @change_set_persister ||= ChangeSetPersister.new(
        metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
        storage_adapter: Valkyrie.config.storage_adapter
      )
    end
  end
end
