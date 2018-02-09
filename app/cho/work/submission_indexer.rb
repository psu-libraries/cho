# frozen_string_literal: true

module Work
  class SubmissionIndexer
    attr_reader :resource
    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      return {} unless resource.try(:work_type)
      {
        work_type_ssim: label_for_id
      }
    end

    # @return [String]
    # @note returns the label associated with the work_type_id
    def label_for_id
      work_type = Work::Type.find(Valkyrie::ID.new(resource.work_type))
      return resource.work_type if work_type.nil?
      work_type.label
    end
  end
end
