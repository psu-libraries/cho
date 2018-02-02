# frozen_string_literal: true

# Explictly require the seed map so that we create the title field BEFORE the
#   work object gets autoloaded.  This supports the title field being defined on the object
require Rails.root.join('spec', 'support', 'seed_map')

FactoryGirl.define do
  factory :work_submission, aliases: [:work], class: Work::Submission do
    title 'Sample Generic Work'
    work_type 'Generic'

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end
end
