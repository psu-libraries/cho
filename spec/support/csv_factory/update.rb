# frozen_string_literal: true

# Buils a csv file for testing update functions. During the process, it creates new works using
# FactoryBot, and writes a csv file using attributes provided as the update attributes for each work.
module CsvFactory
  class Update
    attr_reader :path

    # @param [Array<Hash>] works hash of attributes and values for the csv
    def initialize(*works)
      Tempfile.open do |csv_file|
        csv_file.write(header)
        works.each { |hash| csv_file.write(work(hash)) }
        @path = csv_file.path
      end
    end

    def unlink
      FileUtils.rm_f(path)
    end

    private

      def header
        fields.unshift('id').to_csv
      end

      def work(hash)
        work = FactoryBot.create(:work)
        hash[:member_of_collection_ids] = work.member_of_collection_ids.to_s
        values(hash).unshift(work.id).to_csv
      end

      def fields
        DataDictionary::Field.all.map(&:label).sort.map(&:to_sym)
      end

      def values(hash)
        fields.map { |field| hash.fetch(field, nil) }
      end
  end
end
