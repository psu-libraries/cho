# frozen_string_literal: true

# @note Passes current_ability to the search builder.
# We should be able to remove this once Blacklight access controls support version 7.
class SearchService < Blacklight::SearchService
  attr_reader :current_ability

  def initialize(config:, user_params: {}, search_builder_class: config.search_builder_class, current_ability:)
    @blacklight_config = config
    @user_params = user_params
    @search_builder_class = search_builder_class
    @current_ability = current_ability
  end

  def search_builder
    Blacklight::AccessControls::SearchBuilder.new(self, ability: current_ability)
  end
end
