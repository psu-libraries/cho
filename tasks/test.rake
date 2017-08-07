# frozen_string_literal: true

require 'rspec/core'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'active_fedora/rake_support'

namespace :cho do
  desc 'Run specs'
  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.rspec_opts = ['--color', '--backtrace']
  end

  namespace :travis do
    desc 'Execute Continuous Integration build (docs, tests with coverage)'
    task rspec: :environment do
      with_test_server do
        Rake::Task['cho:rspec'].invoke
      end
    end

    desc 'Run style checker'
    RuboCop::RakeTask.new(:rubocop) do |task|
      task.requires << 'rubocop-rspec'
      task.fail_on_error = true
    end
  end
end
