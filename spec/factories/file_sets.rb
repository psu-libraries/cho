# frozen_string_literal: true

# Explictly require the seed map so that we create the title field BEFORE the
#   work object gets autoloaded.  This supports the title field being defined on the object
require Rails.root.join('spec', 'support', 'seed_map')

FactoryBot.define do
  factory :file_set, class: Work::FileSet do
    title { 'Original File Name' }
    transient do
      work { nil }
    end

    to_create do |resource, attributes|
      fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      work = attributes.work
      work ||= FactoryBot.build(:work_submission)
      work.member_ids << fileset.id
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
      fileset
    end
  end

  trait :with_member_file do
    to_create do |resource, attributes|
      temp_file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt'))
      file = Work::File.new(original_filename: temp_file.original_filename)
      file_change_set = Work::FileChangeSet.new(file)
      result = Transaction::Operations::File::Create.new.call(file_change_set, temp_file: temp_file)
      raise result.failure if result.failure?

      resource.member_ids = [result.success.id]
      fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      work = attributes.work
      work ||= FactoryBot.build(:work_submission)
      work.member_ids << fileset.id
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
      fileset
    end
  end

  trait :with_preservation_file do
    to_create do |resource, attributes|
      result = FileFactory.new.hello_world

      resource.member_ids = [result.success.id]
      fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      work = attributes.work
      work ||= FactoryBot.build(:work_submission)
      work.member_ids << fileset.id
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
      fileset
    end
  end

  trait :with_missing_file do
    to_create do |resource, attributes|
      result = FileFactory.new.hello_world
      FileUtils.rm_f(result.success.resource.path)

      resource.member_ids = [result.success.id]
      fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      work = attributes.work
      work ||= FactoryBot.build(:work_submission)
      work.member_ids << fileset.id
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
      fileset
    end
  end

  trait :with_redacted_preservation_file do
    to_create do |resource, attributes|
      result = FileFactory.new(use: Vocab::FileUse.RedactedPreservationMasterFile).hello_world

      resource.member_ids = [result.success.id]
      fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      work = attributes.work
      work ||= FactoryBot.build(:work_submission)
      work.member_ids << fileset.id
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
      fileset
    end
  end

  trait :with_service_file do
    to_create do |resource, attributes|
      result = FileFactory.new(use: Valkyrie::Vocab::PCDMUse.ServiceFile).hello_world

      resource.member_ids = [result.success.id]
      fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      work = attributes.work
      work ||= FactoryBot.build(:work_submission)
      work.member_ids << fileset.id
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
      fileset
    end
  end

  trait :with_access_file do
    to_create do |resource, attributes|
      result = FileFactory.new(use: Vocab::FileUse.AccessFile).hello_world

      resource.member_ids = [result.success.id]
      fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
      work = attributes.work
      work ||= FactoryBot.build(:work_submission)
      work.member_ids << fileset.id
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
      fileset
    end
  end
end
