# frozen_string_literal: true

module Work
  module Import
    # Creates a list of change sets from the CSV file
    #  Each item in the list is a change set that can be persisted if valid
    #
    # change_set_list = CSVDryRun.run('csv_data.csv')
    #
    # The first line of the csv file is expected to be the header.  The header items correspond to field in the datadictionary
    # member_of_collection_ids,work_type_id,title
    #
    class CsvDryRun
      def self.run(csv_file_name)
        reader = CsvReader.new(::File.new(csv_file_name, 'r'))
        reader.map do |work_hash|
          WorkHashValidator.new(work_hash).change_set
        end
      end
    end
  end
end
