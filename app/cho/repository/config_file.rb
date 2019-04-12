# frozen_string_literal: true

module Repository
  class ConfigFile
    attr_reader :config, :requirements, :name

    # @param [Pathname] file
    # @param [Hash] requirements
    def initialize(file:, requirements:)
      @config = YAML.safe_load(File.open(file)).fetch('production', {})
      @requirements = requirements
      @name = file.basename.to_s
    end

    delegate :keys, to: :config

    def validate
      requirements.each do |requirement|
        setting = JSON.parse(requirement.values.first.to_json, object_class: OpenStruct)
        property = requirement.keys.first
        check_requirement(setting: setting, property: property)
        check_directory(setting: setting, property: property)
      end
    end

    private

      def check_requirement(property:, setting:)
        return if keys.include?(property) || !setting.required
        raise Configuration::Error, "#{property} is a required key in #{name}"
      end

      def check_directory(property:, setting:)
        return unless setting.directory
        directory_exists(property)
        directory_writable(property: property, setting: setting)
      end

      def directory_exists(value)
        path = Pathname.new(config.fetch(value))
        return if path.exist? && path.readable?
        raise Configuration::Error, "#{config.fetch(value)} must be present and readable in #{name}"
      end

      def directory_writable(property:, setting:)
        return if Pathname.new(config.fetch(property)).writable? || !setting.directory.writable
        raise Configuration::Error, "#{config.fetch(property)} must be writable in #{name}"
      end
  end
end
