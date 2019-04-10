# frozen_string_literal: true

module Metrics
  class Repository
    WHITELIST = ['localhost', 'qa'].freeze

    class ResetError < StandardError; end

    class << self
      def reset
        raise ResetError, "Reset not allowed for #{ENV['service_name']}" unless WHITELIST.include?(ENV['service_name'])

        Valkyrie.config.metadata_adapter.resource_factory.orm_class.connection.truncate('orm_resources')
        Blacklight.default_index.connection.delete_by_query('*:*')
        Blacklight.default_index.connection.commit
        reset_directories
        Rails.application.load_seed
      end

      def reset_directories
        reset_directory(Cho::Application.config.storage_directory)
        reset_directory(Cho::Application.config.network_ingest_directory) if Rails.env.test?
        reset_directory(Cho::Application.config.extraction_directory)
      end

      private

        def reset_directory(path)
          if path.exist?
            path.children.map { |child| FileUtils.rm_rf(child) }
          else
            FileUtils.mkdir(path.to_s)
          end
        end
    end
  end
end
