# frozen_string_literal: true

class MetadataFieldPresenter
  attr_reader :field, :document

  delegate :label, :display_transformation, to: :field

  def initialize(field:, document:)
    @field = field
    @document = document
  end

  def content
    @content ||= document.send(field.method_name)
  end

  delegate :present?, :blank?, to: :content

  def paragraphs
    return [] if blank?
    content.join("\n").split(/\n+/)
  end
end
