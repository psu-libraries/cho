# frozen_string_literal: true

module Agent
  module Import
    class CsvReader < Work::Import::CsvReader
      delegate :each, :map, to: :csv_hashes
    end
  end
end
