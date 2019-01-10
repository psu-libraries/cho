# frozen_string_literal: true

# Explictly require the seed map so that we create the title field BEFORE the
#   work object gets autoloaded.  This supports the title field being defined on the object
require Rails.root.join('spec', 'support', 'seed_map')

FactoryBot.define do
  factory :work_submission, aliases: [:work], class: Work::Submission do
    title { 'Sample Generic Work' }
    work_type_id { Work::Type.find_using(label: 'Generic').first.id }

    transient do
      collection_title { 'Sample Archival Collection' }
    end

    member_of_collection_ids do
      if @build_strategy.is_a? FactoryBot::Strategy::Build
        build(:collection, title: collection_title).id
      else
        create(:collection, title: collection_title).id
      end
    end

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end

  trait :with_file do
    transient do
      filename { 'hello_world.txt' }
    end

    to_create do |resource, evaluator|
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', evaluator.filename))
      change_set = Work::SubmissionChangeSet.new(resource, file: [file])
      ChangeSetPersister.new(
        metadata_adapter: Valkyrie::MetadataAdapter.find(:indexing_persister),
        storage_adapter: Valkyrie.config.storage_adapter
      ).validate_and_save(change_set: change_set, resource_params: { file: file })
    end
  end

  trait :with_creator do
    creator do
      if @build_strategy.is_a? FactoryBot::Strategy::Build
        { agent: build(:agent).id, role: MockRDF.relators.first.to_uri.to_s }
      else
        { agent: create(:agent).id, role: MockRDF.relators.first.to_uri.to_s }
      end
    end
  end
end
