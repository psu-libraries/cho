# frozen_string_literal: true

require './spec/support/csv_factory/update'

module CsvFactory
  class AgentUpdate < Update
    private

      def work(hash)
        agent = FactoryBot.create(:agent)
        "#{agent.id},#{values(hash).join(',')}\n"
      end

      def fields
        [:given_name, :surname]
      end
  end
end
