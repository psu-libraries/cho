# frozen_string_literal: true

module Repository
  class Configuration
    class Error < StandardError; end

    REQUIREMENTS = {
      'application.yml' => [
        { 'service_name' => :required },
        { 'service_instance' => :required },
        { 'virtual_host' => :required },
        { 'network_ingest_directory' => :required_directory },
        { 'extraction_directory' => :required_directory },
        { 'storage_directory' => :required_directory }
      ]
    }.freeze

    def self.check
      files = Rails.root.join('config').children
      check_files = files.select { |file| REQUIREMENTS.keys.include?(file.basename.to_s) }
      check_files.each do |file|
        ConfigFile.new(file: file, requirements: REQUIREMENTS[file.basename.to_s]).validate
      end
    end
  end
end
