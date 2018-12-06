# frozen_string_literal: true

json.extract! agent, :id, :given_name, :surname, :created_at, :updated_at
json.url agent_resource_url(agent, format: :json)
