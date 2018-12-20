# frozen_string_literal: true

# A primary resource type in CHO, a file contains binary data and description.
# Files are indexed both in Solr and and Postgres using the {IndexingAdapter}.

require 'mime/types'

class Work::File < Valkyrie::Resource
  include CommonQueries
  include WithUseType

  attribute :original_filename, Valkyrie::Types::String
  attribute :file_identifier, Valkyrie::Types::ID.optional
  attribute :fits_output, Valkyrie::Types::String

  # @return [String] path to binary file
  def path
    return unless file_identifier

    file_identifier.id.gsub('disk://', '')
  end

  # @todo Update to use FITS data when available.
  def mime_type
    MIME::Types.type_for(path)
  end

  def extractable?
    (mime_type.map(&:to_s) & ['application/pdf', 'text/html', 'text/markdown', 'text/plain']).present?
  end
end
