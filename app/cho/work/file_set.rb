# frozen_string_literal: true

# A primary resource type in CHO, a file set contains other File resources each of which relates
# to a single original binary source.
# File sets are indexed both in Solr and and Postgres using the {IndexingAdapter}.
class Work::FileSet < Valkyrie::Resource
  enable_optimistic_locking
  include Valkyrie::Resource::AccessControls
  include CommonQueries
  include DataDictionary::FieldsForObject

  attribute :member_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID)

  # @note Define "getters" for each kind of use file in the file set.
  Repository::FileUse.uris.each do |uri|
    define_method Repository::FileUse.new(uri.fragment).get_method do
      files.select do |file|
        file.send(Repository::FileUse.new(uri.fragment).ask_method)
      end.first
    end
  end

  alias :thumbnail :thumb

  # @return [Array<Work::File>]
  # @todo We may need to be able to reload the files cache.
  def files
    @files ||= member_ids.map { |id| Work::File.find(id) }
  end

  # @return [Work::File] the preservation file
  # @note Overrides meta-defined method above
  def preservation
    preservation_redacted || files.select(&:preservation?).first
  end

  # @return [Work::File] file from which we extract the text
  # Prefer the redacted preservation file; otherwise, chose either the preservation, access, or service file.
  def text_source
    preservation || access || service
  end

  def representative?
    alternate_ids.empty?
  end

  def self.model_name
    Name.new(self)
  end

  # @note Use a custom Name class to preserve default behaviors while overriding others
  class Name < ActiveModel::Name
    def i18n_key
      'file_set'
    end

    def human
      'File set'
    end
  end
end
