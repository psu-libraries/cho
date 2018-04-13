# frozen_string_literal: true

# Explictly require the seed map so that we create the title field BEFORE the
#   work object gets autoloaded.  This supports the title field being defined on the object
require Rails.root.join('spec', 'support', 'seed_map')

FactoryGirl.define do
  factory :work_submission, aliases: [:work], class: Work::Submission do
    title 'Sample Generic Work'
    work_type_id { Work::Type.find_using(label: 'Generic').first.id }

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end

  trait :with_file do
    to_create do |resource|
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt'))
      change_set = Work::SubmissionChangeSet.new(resource, file: [file])
      ChangeSetPersister.new(
        metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
        storage_adapter: Valkyrie.config.storage_adapter
      ).validate_and_save(change_set: change_set, resource_params: { file: file })
    end
  end
end
