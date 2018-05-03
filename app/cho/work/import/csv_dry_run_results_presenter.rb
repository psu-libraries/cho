# frozen_string_literal: true

module Work
  module Import
    # Presents the results of the dry run in a nice way for display
    class CsvDryRunResultsPresenter
      delegate :each, :to_a, to: :change_set_list
      attr_reader :change_set_list

      def initialize(change_set_list)
        @change_set_list = change_set_list
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
