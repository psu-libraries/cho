# frozen_string_literal: true

module Metrics
  class Repository
    WHITELIST = ['localhost', 'qa'].freeze

    class ResetError < StandardError; end

    def self.reset
      raise ResetError, "Reset not allowed for #{ENV['service_name']}" unless WHITELIST.include?(ENV['service_name'])
      Valkyrie.config.metadata_adapter.resource_factory.orm_class.connection.truncate('orm_resources')
      Blacklight.default_index.connection.delete_by_query('*:*')
      Blacklight.default_index.connection.commit
      reset_directories
      Rails.application.load_seed
    end

    def self.reset_directories
      FileUtils.rm_rf(Rails.root.join('tmp', 'files').to_s)
      FileUtils.mkdir(Rails.root.join('tmp', 'files').to_s)
      FileUtils.rm_rf(Rails.root.join('tmp', "ingest-#{Rails.env}").to_s)
      FileUtils.mkdir(Rails.root.join('tmp', "ingest-#{Rails.env}").to_s)
      FileUtils.rm_rf(Rails.root.join('tmp', "extract-#{Rails.env}").to_s)
      FileUtils.mkdir(Rails.root.join('tmp', "extract-#{Rails.env}").to_s)
    end
  end
end
