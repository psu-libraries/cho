# frozen_string_literal: true

module Batch
  class DeletePresenter
    attr_reader :resource, :children

    delegate :id, :title, to: :resource

    def initialize(resource)
      @resource = resource
      @children = (titles_for(:members) + titles_for(:file_sets) + titles_for(:files)).flatten
    end

    def confirmation_title
      I18n.t('cho.batch.delete.title', title: title.first, count: children.count)
    end

    private

      def titles_for(type)
        contained_resources(type).map do |member|
          if type == :files
            "File: #{member.original_filename}"
          else
            ["#{member.model_name.human}: #{member.title.first}"] + self.class.new(member).children
          end
        end
      end

      def contained_resources(type)
        return [] unless resource.try(type)

        resource.send(type)
      end
  end
end
