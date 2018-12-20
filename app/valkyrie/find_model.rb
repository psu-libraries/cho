# frozen_string_literal: true

class FindModel
  def self.queries
    [:find_model]
  end

  attr_reader :query_service
  delegate :resource_factory, to: :query_service
  delegate :orm_class, to: :resource_factory

  def initialize(query_service:)
    @query_service = query_service
  end

  def find_model(model:, id:)
    raise ArgumentError, 'id must be a Valkyrie::ID' unless id.is_a? Valkyrie::ID

    results = orm_class.where(internal_resource: model.to_s).where(id: id).lazy.map do |orm_object|
      resource_factory.to_resource(object: orm_object)
    end
    results.first
  end
end
