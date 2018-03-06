# frozen_string_literal: true

namespace :cho do
  namespace :benchmark do
    desc 'Add works to a collection'
    task :collections, [:length] => [:environment] do |_t, args|
      length = args.fetch(:length, 10).to_i
      adapter = IndexingAdapter.new(metadata_adapter: Valkyrie::Persistence::Postgres::MetadataAdapter.new,
                                    index_adapter: Valkyrie::MetadataAdapter.find(:index_solr))

      collection = Collection::Archival.new(
        title: ['Test Collection'],
        description: ['Collection for adding a large number of test works']
      )

      output = adapter.persister.buffer_into_index do |buffered_adapter|
        buffered_adapter.persister.save(resource: collection)
      end

      $stdout = File.new("tmp/collections_#{length}.csv", 'w')
      $stdout.sync = true

      Benchmark.benchmark("User,System,Total,Real\n", 0, "%u,%y,%t,%r\n") do |bench|
        adapter.persister.buffer_into_index do |buffered_adapter|
          work_type = Work::Type.find_using(label: 'Generic').first
          (1..length).each do |count|
            work = Work::Submission.new(
              title: ["Sample Work #{count}"],
              work_type: work_type.id,
              member_of_collection_ids: output.first.id
            )
            bench.report { buffered_adapter.persister.save(resource: work) }
          end
        end
      end
    end
  end
end
