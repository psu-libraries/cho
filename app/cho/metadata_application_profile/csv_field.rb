# frozen_string_literal: true

require 'csv'

module MetadataApplicationProfile
  class CsvField < Draper::Decorator
    delegate_all

    attr_reader :attributes

    # @param [MetadataApplicationProfile::Field] metadata_application_profile_field
    # @param [Array<Symbol, String>] attributes defaults ::default_attributes
    def initialize(metadata_application_profile_field, attributes = self.class.default_attributes)
      super(metadata_application_profile_field)
      @attributes = attributes.map(&:to_sym)
    end

    # @return [String]
    def to_csv
      values = model.attributes.slice(*attributes).values
      ::CSV.generate_line(values)
    end

    # @return [MetadataApplicationProfile::Field]
    def parse(csv_string)
      change_set = nil
      ::CSV.parse(csv_string) do |row|
        new_attributes = Hash[attributes.zip(row)]
        change_set = FieldChangeSet.new(Field.new)
        change_set.validate(new_attributes)
      end
      model.class.new(HashWithIndifferentAccess.new(change_set.fields))
    end

    # @note the order of the array is the order of columns in the csv file
    def self.default_attributes
      [:label, :field_type, :requirement_designation,
       :validation, :multiple, :controlled_vocabulary,
       :default_value, :display_name, :display_transformation]
    end
  end
end
