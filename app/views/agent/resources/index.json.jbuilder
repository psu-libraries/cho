# frozen_string_literal: true

json.array! @agents, partial: 'agent/resources/agent', as: :agent
