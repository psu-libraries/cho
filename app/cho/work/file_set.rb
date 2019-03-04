# frozen_string_literal: true

# A primary resource type in CHO, a file set contains other File resources each of which relates
# to a single original binary source.
# File sets are indexed both in Solr and and Postgres using the {IndexingAdapter}.
class Work::FileSet < Valkyrie::Resource
  include CommonQueries
  include DataDictionary::FieldsForObject

  attribute :member_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID)

  # @return [Array<Work::File>]
  # @todo We may need to be able to reload the files cache.
  def files
    @files ||= member_ids.map { |id| Work::File.find(id) }
  end

  # @return [Work::File] the extracted text file
  def text
    files.select(&:text?).first
  end

  # @return [Work::File] the preservation file
  def preservation
    files.select(&:preservation?).first
  end

  # @return [Work::File] the redacted preservation file
  def preservation_redacted
    files.select(&:preservation_redacted?).first
  end

  # @return [Work::File] the access file
  def access
    files.select(&:access?).first
  end

  # @return [Work::File] the service file
  def service
    files.select(&:service?).first
  end

  # @return [Work::File] the thumbnail file
  def thumbnail
    files.select(&:thumbnail?).first
  end

  # @return [Work::File] file from which we extract the text
  # Prefer the redacted preservation file; otherwise, chose either the preservation, access, or service file.
  def text_source
    (preservation_redacted || preservation) || access || service
  end

  def representative?
    alternate_ids.empty?
  end
end
