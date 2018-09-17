# frozen_string_literal: true

# Explictly require the seed map so that we create the title field BEFORE the
#   work object gets autoloaded.  This supports the title field being defined on the object
require Rails.root.join('spec', 'support', 'seed_map')

FactoryBot.define do
  factory :work_file, class: Work::File do
    original_filename { 'original_name' }
    use { [Valkyrie::Vocab::PCDMUse.PreservationMasterFile] }

    to_create do |resource|
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end
  end
end
