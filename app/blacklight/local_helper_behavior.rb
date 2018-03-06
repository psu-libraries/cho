# frozen_string_literal: true

module LocalHelperBehavior
  # @note Wrap the output from {link_to_document} in a {raw} call so that it will render properly.
  def render_link_to_collection(options = {})
    raw(options[:document].member_of_collections.map do |document|
      link_to_document(document, document_show_link_field(document))
    end.join(', '))
  end
end
