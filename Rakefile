# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

# Load rake tasks for development and testing
unless Rails.env.production?
  require 'solr_wrapper/rake_task'
  Dir.glob(File.expand_path('../tasks/*.rake', __FILE__)).each do |f|
    load(f)
  end
end

Rails.application.load_tasks
