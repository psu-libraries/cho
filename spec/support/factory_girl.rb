# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
  to_create do |resource|
    Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
  end
end
