# frozen_string_literal: true

namespace :cho do
  namespace :benchmark do
    desc 'Benchmark a collection with many works'
    task :collections, [:length] => [:environment] do |_t, args|
      metric = Metrics::Collection.new(length: args.fetch(:length, 10).to_i)
      metric.run
    end

    desc 'Benchmark many works with files'
    task :works, [:length] => [:environment] do |_t, args|
      metric = Metrics::Work.new(length: args.fetch(:length, 10).to_i)
      file_size = args.fetch(:file_size, 50).to_i
      metric.file_size = file_size
      metric.run
    end

    desc 'Clean out the application and re-seed the database'
    task reset: :environment do
      Metrics::Repository.reset
    end
  end
end
