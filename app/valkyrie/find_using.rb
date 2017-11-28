# frozen_string_literal: true

class FindUsing
  def self.queries
    [:find_using]
  end

  attr_reader :query_service
  delegate :resource_factory, to: :query_service
  delegate :orm_class, to: :resource_factory

  def initialize(query_service:)
    @query_service = query_service
  end

  def find_using(query)
    raise ArgumentError, 'only one query term is supported' if query.length > 1
    sql = "SELECT * FROM orm_resources WHERE metadata @> '{\"#{query.keys.first}\":\"#{query.values.first}\"}';"
    run_query(sql)
  end

  def run_query(sql)
    orm_class.find_by_sql(sql).lazy.map do |object|
      resource_factory.to_resource(object: object)
    end
  end
end
