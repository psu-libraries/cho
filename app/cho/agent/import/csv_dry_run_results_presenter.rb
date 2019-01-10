# frozen_string_literal: true

module Agent
  module Import
    class CsvDryRunResultsPresenter < Work::Import::CsvDryRunResultsPresenter
      def bag_errors
        []
      end

      def bag
        # noop
      end
    end
  end
end
