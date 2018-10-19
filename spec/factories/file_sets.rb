# frozen_string_literal: true

# Explictly require the seed map so that we create the title field BEFORE the
#   work object gets autoloaded.  This supports the title field being defined on the object
require Rails.root.join('spec', 'support', 'seed_map')

FactoryBot.define do
  factory :file_set, class: Work::FileSet do
    title { 'Original File Name' }

    to_create do |resource|
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end

  trait :with_member_file do
    to_create do |resource|
      temp_file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt'))
      file = Work::File.new(original_filename: temp_file.original_filename)
      file_change_set = Work::FileChangeSet.new(file)
      result = Transaction::Operations::File::Create.new.call(file_change_set, temp_file: temp_file)
      raise result.failure if result.failure?
      resource.member_ids = [result.success.id]
      Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    end
  end
end
