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
        send(requirement.values.first, requirement.keys.first)
      end
    end

    private

      def required(value)
        return if keys.include?(value)
        raise Configuration::Error, "#{value} is a required key in #{name}"
      end

      def required_directory(value)
        required(value)
        return if Pathname.new(config.fetch(value)).exist?
        raise Configuration::Error, "#{config.fetch(value)} is a required directory in #{name}"
      end
  end
end
