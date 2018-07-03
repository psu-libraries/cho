# frozen_string_literal: true

module Work
  class FileChangeSet < Valkyrie::ChangeSet
    property :use, multiple: true, required: true, default: [Valkyrie::Vocab::PCDMUse.PreservationMasterFile]
    validates :use, 'work/use_type': true

    property :original_filename, multiple: false, required: true
    validates :original_filename, presence: true

    property :fits_output, multiple: false, required: false
  end
end
