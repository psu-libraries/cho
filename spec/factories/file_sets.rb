# frozen_string_literal: true

# Explictly require the seed map so that we create the title field BEFORE the
#   work object gets autoloaded.  This supports the title field being defined on the object
require Rails.root.join('spec', 'support', 'seed_map')

FactoryBot.define do
  factory :file_set, aliases: [:representative_file_set], class: Work::FileSet do
    title { 'Original File Name' }
    transient do
      work { nil }
    end

    factory :preservation_file_set do
      alternate_ids { [rand(1..1_000)] }
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
      file_factory = FileFactory.new
      file_factory.build_file_set(resource: resource, attributes: attributes)
    end
  end

  trait :with_preservation_file do
    to_create do |resource, attributes|
      file_factory = FileFactory.new(
        use: Vocab::FileUse.PreservationMasterFile,
        text: 'Hello World! (preservation)'
      )
      file_factory.build_file_set(resource: resource, attributes: attributes)
    end
  end

  trait :with_missing_file do
    to_create do |resource, attributes|
      file_factory = FileFactory.new
      fileset = file_factory.build_file_set(resource: resource, attributes: attributes)
      FileUtils.rm_f(fileset.files.first.path)
      fileset
    end
  end

  trait :with_redacted_preservation_file do
    to_create do |resource, attributes|
      file_factory = FileFactory.new(
        use: Vocab::FileUse.RedactedPreservationMasterFile,
        text: 'Hello World! (redacted preservation)'
      )
      file_factory.build_file_set(resource: resource, attributes: attributes)
    end
  end

  trait :with_service_file do
    to_create do |resource, attributes|
      file_factory = FileFactory.new(
        use: Vocab::FileUse.ServiceFile,
        text: 'Hello World! (service)'
      )
      file_factory.build_file_set(resource: resource, attributes: attributes)
    end
  end

  trait :with_access_file do
    to_create do |resource, attributes|
      file_factory = FileFactory.new(
        use: Vocab::FileUse.AccessFile,
        text: 'Hello World! (access)'
      )
      file_factory.build_file_set(resource: resource, attributes: attributes)
    end
  end

  trait :with_extracted_text_file do
    to_create do |resource, attributes|
      file_factory = FileFactory.new(
        use: Vocab::FileUse.ExtractedText,
        text: 'Hello World! (extracted text)'
      )
      file_factory.build_file_set(resource: resource, attributes: attributes)
    end
  end

  trait :with_thumbnail_file do
    to_create do |resource, attributes|
      file_factory = FileFactory.new(
        use: Vocab::FileUse.ThumbnailImage,
        text: 'Hello World! (thumbnail)'
      )
      file_factory.build_file_set(resource: resource, attributes: attributes)
    end
  end
end
