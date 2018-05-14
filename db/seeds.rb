# Loads required fields, schemas, and work types for use with CHO
class SeedMAP
  class << self

    def create
      return unless ActiveRecord::Base.connection.table_exists? 'orm_resources'
      DataDictionary::CsvImporter.load_dictionary
      Schema::Configuration.new.load_work_types
    end
  end
end

SeedMAP.create
