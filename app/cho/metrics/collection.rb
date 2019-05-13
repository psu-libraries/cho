# frozen_string_literal: true

require 'newrelic_rpm'

module Metrics
  class Collection
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    attr_reader :length

    # @param [Integer] length how many times the metric will be run
    # @param [File, #write] output where the benchmark results are written
    def initialize(length: 10, output: nil)
      @length = length
      @output = output
    end

    def run
      current_stdout = $stdout
      $stdout = output
      $stdout.sync = true
      benchmark
      $stdout = current_stdout
    end
    add_transaction_tracer :run, category: :task

    def benchmark
      Benchmark.benchmark("#{I18n.t('cho.metrics.benchmark_heading')}\n", 0, "%u,%y,%t,%r\n") do |bench|
        (1..length).each do |count|
          bench.report { work_resource(count) }
        end
      end
    end

    def output
      @output ||= File.new("tmp/#{i18n_key.gsub(/\./, '_')}_#{length}.csv", 'w')
    end

    private

      def collection
        @collection ||= build_resource(
          change_set: ::Collection::ArchivalChangeSet.new(::Collection::Archival.new),
          resource_params: collection_params
        )
      end

      def build_resource(change_set:, resource_params:)
        change_set.prepopulate!
        resource = change_set_persister.validate_and_save(change_set: change_set, resource_params: resource_params)
        raise StandardError, "Collection failed to save: #{resource.errors.full_messages}" if resource.errors.present?

        resource
      end

      def collection_params
        {
          title: [I18n.t("#{i18n_key}.title")],
          description: [I18n.t("#{i18n_key}.description")],
          workflow: 'default',
          access_level: 'public'
        }
      end

      # @todo Use Faker::String.random in description to input unicode characters and check for conversion errors.
      def work_resource(count)
        build_resource(
          change_set: ::Work::SubmissionChangeSet.new(::Work::Submission.new),
          resource_params: work_params(count)
        )
      end

      def work_params(count)
        {
          title: [I18n.t("#{i18n_key}.work_title", count: count)],
          creator: [{ agent: agent.id.to_s, role: role }],
          date_created: [Faker::Date.between(10.years.ago, 1.year.ago).strftime('%A, %b %d, %Y')],
          subject: Faker::Lorem.words(4, true),
          location: [Faker::StarTrek.location],
          description: [Faker::Lorem.paragraph, Faker::Lorem.paragraph],
          genre: [Faker::Food.dish],
          repository: [Faker::Company.bs.titleize],
          rights_statement: [Faker::HowIMetYourMother.quote],
          cataloger: [Faker::SiliconValley.character],
          date_cataloged: [Faker::Time.between(30.days.ago, Date.today, :day).strftime('%Y-%m-%d')],
          work_type_id: work_type_id,
          home_collection_id: [collection.id]
        }
      end

      def work_type_id
        @work_type_id ||= ::Work::Type.find_using(label: 'Generic').first.id
      end

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(
          metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
          storage_adapter: Valkyrie.config.storage_adapter
        )
      end

      def i18n_key
        "cho.#{self.class.to_s.gsub(/::/, '.').downcase}"
      end

      def agent
        resource = Agent::Resource.new(given_name: Faker::Name.first_name, surname: Faker::Name.last_name)
        Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      end

      def role
        relators.sample
      end

      def relators
        @relators ||= RDF::Vocab::MARCRelators.to_a
      end
  end
end
