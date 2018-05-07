# frozen_string_literal: true

namespace :cho do
  desc 'Clean out the dev environment and re-seed the database'
  task clean: :environment do
    Rake::Task['cho:benchmark:reset'].invoke
  end
end
