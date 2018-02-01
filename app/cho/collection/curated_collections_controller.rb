# frozen_string_literal: true

module Collection
  class CuratedCollectionsController < ApplicationController
    include ControllerBehaviors

    private

      def change_set_class
        CuratedChangeSet
      end

      def resource_class
        Curated
      end
  end
end
