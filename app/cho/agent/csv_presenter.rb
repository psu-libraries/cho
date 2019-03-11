# frozen_string_literal: true

require 'csv'

module Agent
  class CsvPresenter
    attr_reader :agent_list, :export_attributes

    def initialize(agent_list)
      @export_attributes = CsvAgent.default_attributes.map(&:to_s)
      @agent_list = agent_list
    end

    def to_csv
      csv_header + csv_lines
    end

    private

      def csv_header
        headers = export_attributes
        ::CSV.generate_line(headers)
      end

      def csv_lines
        agent_list.map do |agent|
          csv_line(agent)
        end.join('')
      end

      def csv_line(agent)
        return '' if agent.blank?

        CsvAgent.new(agent, export_attributes).to_csv
      end
  end
end
