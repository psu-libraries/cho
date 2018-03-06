# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  def internal_resource
    Array.wrap(self['internal_resource_tsim']).first.constantize
  end

  # @return [Array<Work::File>]
  def files
    Array.wrap(self['files_ssim']).map do |id|
      Work::File.find(Valkyrie::ID.new(id.sub(/^id-/, '')))
    end
  end

  # @return [Array<SolrDocument>]
  def member_of_collections
    Array.wrap(self['member_of_collection_ids_ssim']).map do |id|
      SolrDocument.find(id.sub(/^id-/, ''))
    end
  end
end
