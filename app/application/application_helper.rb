# frozen_string_literal: true

module ApplicationHelper
  # @todo figure out how to use polymorphic_path, potentially with SolrDocument::ModelWrapper in Hyrax
  def edit_cho_resource_path
    if @document.internal_resource == Work::Submission
      edit_work_path
    else
      send("edit_#{@document.internal_resource.model_name.param_key}_path", @document.id)
    end
  end
end
