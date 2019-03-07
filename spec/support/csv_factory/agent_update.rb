# frozen_string_literal: true

require './spec/support/csv_factory/update'

module CsvFactory
  class AgentUpdate < Update
    private

      def work(hash)
        agent = FactoryBot.create(:agent)
        values(hash).unshift(agent.id).to_csv
      end

      def fields
        [:given_name, :surname]
      end
  end
end
