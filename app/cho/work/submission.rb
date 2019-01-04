# frozen_string_literal: true

# A primary resource type in CHO, a work contains {Work::File} resources as well as other works with attributes
# for description.
# Works are indexed both in Solr and and Postgres using the {IndexingAdapter}.
module Work
  class Submission < Valkyrie::Resource
    enable_optimistic_locking
    include Valkyrie::Resource::AccessControls
    include DataDictionary::FieldsForObject
    include CommonQueries

    attribute :work_type_id, Valkyrie::Types::ID.optional

    # A list of Work::FileSet resources.
    #  The stored valkyrie ids for file sets attached to the submission
    attribute :file_set_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID)

    attribute :batch_id, Valkyrie::Types::String.optional

    # Accessors needed for shrine to send the temporary uploaded file
    #  to the controller
    # For the moment we are uploading a single file.
    attr_accessor :file_data, :cached_file_data, :file

    def self.model_name
      Name.new(self)
    end

    # @note Use a custom Name class to preserve default behaviors while overriding others
    class Name < ActiveModel::Name
      def i18n_key
        'work'
      end

      def human
        'Work'
      end
    end

    def file_sets
      @file_sets ||= file_set_ids.map { |id| Work::FileSet.find(id) }
    end

    def representative_file_set
      file_sets.select(&:representative?).first || file_sets.first || NullRepresentativeFileSet.new
    end

    def attributes
      super
    end

    class NullRepresentativeFileSet
      Thumbnail = Struct.new('File', :path)
      def thumbnail
        @thumbnail ||= Thumbnail.new(nil)
      end
    end
  end
end
