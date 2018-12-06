# frozen_string_literal: true

require 'csv'

module Agent
  class CsvAgent < Draper::Decorator
    delegate_all

    attr_reader :attributes

    # @param [Resource::Agent] agent
    # @param [Array<Symbol, String>] attributes defaults ::default_attributes
    def initialize(agent, attributes = self.class.default_attributes)
      super(agent)
      @attributes = attributes.map(&:to_sym)
    end

    # @return [String]
    def to_csv
      values = model.attributes.slice(*attributes).values
      ::CSV.generate_line(values)
    end

    # @note the order of the array is the order of columns in the csv file
    def self.default_attributes
      [:id, :surname, :given_name]
    end
  end
end
