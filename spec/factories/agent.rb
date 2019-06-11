# frozen_string_literal: true

FactoryBot.define do
  factory :agent, aliases: [:secret_agent], class: Agent::Resource do
    given_name { 'John' }
    surname { 'Doe' }

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end

  trait :generate_name do
    given_name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
  end
end
