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
    model = query.delete(:model)
    sql = "SELECT * FROM orm_resources WHERE #{build_where_clause(query, model)};"
    run_query(sql)
  end

  def run_query(sql)
    orm_class.find_by_sql(sql).lazy.map do |object|
      resource_factory.to_resource(object: object)
    end
  end

  def build_where_clause(query, model)
    clauses = []
    query.each_key do |key|
      value = query[key]
      clause = if value.is_a?(String)
                 "metadata @> '{\"#{key}\":[\"#{PG::Connection.escape_string(value)}\"]}'"
               elsif value.nil?
                 "metadata->>'#{key}' is null"
               else
                 "metadata @> '{\"#{key}\":[#{value}]}'"
               end
      clauses.push(clause)
    end
    clauses.push("internal_resource = '#{model}'") if model
    clauses.join(' AND ')
  end
end
