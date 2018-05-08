# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  to_create do |resource|
    Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
  end

  after :build do |record|
    record.new_record = false if record.id.present?
  end
end
