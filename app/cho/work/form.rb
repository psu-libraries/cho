# frozen_string_literal: true

class Work::Form
  attr_reader :change_set

  delegate :model, :model_name, :title, :metadata_schema, :errors, to: :change_set
  delegate :url_helpers, to: 'Rails.application.routes'

  def initialize(change_set)
    @change_set = change_set
  end

  def fields
    return @fields if @fields.present?
    field_ids = metadata_schema.core_fields + metadata_schema.fields
    unordered_fields = field_ids.map { |id| Schema::MetadataField.find(id) }
    @fields = unordered_fields.sort_by(&:order_index)
  end

  def work_type
    @work_type ||= Work::Type.find(Valkyrie::ID.new(change_set.work_type))
  end

  def submit_text
    if @change_set.model.persisted?
      I18n.t('cho.work.edit.submit')
    else
      I18n.t('cho.work.new.submit')
    end
  end

  def form_path
    if @change_set.model.persisted?
      url_helpers.work_path(model)
    else
      url_helpers.works_path
    end
  end

  private

    def metadata_schema
      @metadata_schema ||= work_type.metadata_schema
    end
end
