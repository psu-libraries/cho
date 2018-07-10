# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include DataDictionary::FieldsForSolrDocument

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

  # csv extension
  use_extension(Document::Csv)

  def internal_resource
    internal_resource_name.constantize
  end

  def internal_resource_name
    Array.wrap(self['internal_resource_tsim']).first
  end

  # @return [Array<Work::FileSet>]
  def file_sets
    Array.wrap(self['file_set_ids_ssim']).map do |id|
      Work::FileSet.find(Valkyrie::ID.new(id.sub(/^id-/, '')))
    end
  end

  # @return [Array<SolrDocument>]
  def member_of_collections
    Array.wrap(self['member_of_collection_ids_ssim']).map do |id|
      SolrDocument.find(id.sub(/^id-/, ''))
    end
  end

  def collection?
    internal_resource_name.include?('Collection')
  end

  def work_type
    @work_type ||= Array.wrap(self[:work_type_ssim]).first
  end

  def schema
    @schema ||= Schema::Metadata.where(label: schema_label).first
  end

  def schema_label
    @schema_label ||= if collection?
                        'Collection'
                      else
                        work_type
                      end
  end
end
