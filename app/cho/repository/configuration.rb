# frozen_string_literal: true

module Repository
  class Configuration
    class Error < StandardError; end

    REQUIREMENTS = {
      'application.yml' => [
        { 'service_name' => { required: true } },
        { 'service_instance' => { required: true } },
        { 'virtual_host' => { required: true } },
        { 'network_ingest_directory' => { required: true, directory: { writable: false } } },
        { 'extraction_directory' => { required: true, directory: { writable: true } } },
        { 'storage_directory' => { required: true, directory: { writable: true } } },
        { 'collection_image_directory' => { required: true, directory: { writable: false } } },
        { 'piwik_id' => { required: true } }
      ]
    }.freeze

    def self.check
      files = Rails.root.join('config').children
      check_files = files.select { |file| REQUIREMENTS.key?(file.basename.to_s) }
      check_files.each do |file|
        ConfigFile.new(file: file, requirements: REQUIREMENTS[file.basename.to_s]).validate
      end
    end
  end
end
