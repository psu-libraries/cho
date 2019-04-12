# frozen_string_literal: true

namespace :cho do
  namespace :repository do
    desc 'Check configuration files for validity'
    task check: :environment do
      Repository::Configuration.check
    end
  end
end
