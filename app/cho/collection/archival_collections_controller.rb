# frozen_string_literal: true

module Collection
  class ArchivalCollectionsController < ApplicationController
    include ControllerBehaviors

    private

      def change_set_class
        ArchivalChangeSet
      end

      def resource_class
        Archival
      end
  end
end
