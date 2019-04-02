# frozen_string_literal: true

module LocalHelperBehavior
  # @param options_or_value [Hash, String] value passed by blacklight to render the item in the
  #                                        show, index, and facet displays
  # @note Wrap the output from {link_to_document} in a {raw} call so that it will render properly.
  def render_link_to_collection(options_or_value = {})
    if options_or_value.is_a? Hash
      raw(options_or_value[:document].member_of_collections.map do |document|
        link_to_document(document, document_show_link_field(document))
      end.join(', '))
    else
      # id of item to gte the title for.  This is in the facet context
      doc = SolrDocument.find(options_or_value.sub(/^id-/, ''))
      doc['title_tesim'].first
    end
  end

  # @note Avoids any NoMethodError problems when specifying a custom partial display transformation
  def paragraph_heading(*args)
    # noop
  end
end
