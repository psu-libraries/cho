# frozen_string_literal: true

module CommonQueries
  extend ActiveSupport::Concern

  class_methods do
    def all
      Valkyrie.config.metadata_adapter.query_service.find_all_of_model(model: self).to_a
    end

    delegate :count, :last, :first, to: :all

    def find(id)
      Valkyrie.config.metadata_adapter.query_service.custom_queries.find_model(model: self, id: id)
    end

    def find_using(query)
      query[:model] = self
      Valkyrie.config.metadata_adapter.query_service.custom_queries.find_using(query)
    end
    alias_method :where, :find_using
  end
end
