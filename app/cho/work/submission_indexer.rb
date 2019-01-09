# frozen_string_literal: true

module Work
  class SubmissionIndexer
    attr_reader :resource
    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      return {} unless resource.try(:work_type_id)

      {
        work_type_ssim: label_for_id,
        member_of_collection_ssim: collection_labels_for_ids,
        thumbnail_path_ss: thumbnail_path
      }
    end

    private

      # @return [String]
      # @note returns the label associated with the work_type_id
      def label_for_id
        work_type = Work::Type.find(Valkyrie::ID.new(resource.work_type_id))
        return if work_type.nil?

        work_type.label
      end

      def collection_labels_for_ids
        return unless resource.respond_to?(:member_of_collection_ids)

        Array.wrap(resource.member_of_collection_ids).map do |id|
          SolrDocument.find(id).send(title_field_method)
        end.flatten
      end

      def title_field_method
        @title_field_method ||= DataDictionary::Field.find_using(label: 'title').first.method_name
      end

      def thumbnail_path
        thumbnail = resource.representative_file_set.thumbnail
        return if thumbnail.nil?

        thumbnail.path.to_s
      end
  end
end
