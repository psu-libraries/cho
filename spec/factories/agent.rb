# frozen_string_literal: true

FactoryBot.define do
  factory :agent_agent, class: Agent::Resource do
    sequence(:id)
    given_name { 'John' }
    surname { 'Doe' }

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end
end
