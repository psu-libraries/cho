# frozen_string_literal: true

module Work
  module Import
    # Presents the results of the dry run in a nice way for display
    class CsvDryRunResultsPresenter
      delegate :each, :to_a, to: :change_set_list
      delegate :update?, to: :dry_run

      attr_reader :dry_run

      # @param [CsvDryRun] dry_run
      def initialize(dry_run)
        @dry_run = dry_run
      end

      def change_set_list
        dry_run.results
      end

      def invalid_rows
        @invalid ||= change_set_list.reject(&:valid?)
      end

      def valid_rows
        @valid ||= change_set_list.select(&:valid?)
      end

      def invalid?
        invalid_rows.present?
      end

      def valid?
        valid_rows.present?
      end

      def error_count
        invalid_rows.count
      end
    end
  end
end
