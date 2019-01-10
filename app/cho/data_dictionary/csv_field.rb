# frozen_string_literal: true

require 'csv'

module DataDictionary
  class CsvField < Draper::Decorator
    delegate_all

    attr_reader :attributes

    # @param [DataDictionary::Field] data_dictionary_field
    # @param [Array<Symbol, String>] attributes defaults ::default_attributes
    def initialize(data_dictionary_field, attributes = self.class.default_attributes)
      super(data_dictionary_field)
      @attributes = attributes.map(&:to_sym)
    end

    # @return [String]
    def to_csv
      values = model.attributes.slice(*attributes).values
      ::CSV.generate_line(values)
    end

    # @return [DataDictionary::Field]
    def parse(csv_string)
      change_set = nil
      ::CSV.parse(csv_string) do |row|
        new_attributes = Hash[attributes.zip(row)]
        change_set = FieldChangeSet.new(Field.new)
        change_set.validate(new_attributes)
      end
      model.class.new(change_set.fields.symbolize_keys)
    end

    # @note the order of the array is the order of columns in the csv file
    def self.default_attributes
      [:label, :field_type, :requirement_designation,
       :validation, :multiple, :controlled_vocabulary,
       :default_value, :display_name, :display_transformation,
       :index_type, :help_text, :core_field]
    end
  end
end
