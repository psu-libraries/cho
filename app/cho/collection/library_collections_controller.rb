# frozen_string_literal: true

module Collection
  class LibraryCollectionsController < ApplicationController
    include ControllerBehaviors

    private

      def change_set_class
        LibraryChangeSet
      end

      def resource_class
        Library
      end
  end
end
