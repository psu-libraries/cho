# frozen_string_literal: true

module CommonQueries
  extend ActiveSupport::Concern

  class_methods do
    def all
      Valkyrie.config.metadata_adapter.query_service.find_all_of_model(model: self).to_a
    end

    def count
      all.count
    end

    def find(id)
      Valkyrie.config.metadata_adapter.query_service.custom_queries.find_model(model: self, id: id)
    end
  end
end
