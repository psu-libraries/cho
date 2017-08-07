# frozen_string_literal: true

rails_env = ENV['RAILS_ENV'] || 'development'

config = YAML.safe_load(ERB.new(IO.read(Rails.root.join('config', 'redis.yml'))).result)['resque'].with_indifferent_access
Resque.redis = Redis.new(config.merge(thread_safe: true))
Resque.inline = rails_env == 'test'
Resque.redis.namespace = "cho:#{rails_env}"
Resque.logger.level = Logger::INFO
