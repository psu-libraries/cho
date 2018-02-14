# frozen_string_literal: true

namespace :cho do
  desc 'Clean out the dev environment and re-seed the database'
  task clean: :environment do
    Valkyrie.config.metadata_adapter.resource_factory.orm_class.connection.truncate('orm_resources')
    Blacklight.default_index.connection.delete_by_query('*:*')
    Blacklight.default_index.connection.commit
    Rake::Task['db:seed'].invoke
  end
end
