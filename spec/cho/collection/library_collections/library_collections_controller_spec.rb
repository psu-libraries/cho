# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::LibraryCollectionsController, type: :controller do
  let(:collection) { create_for_repository(:library_collection) }
  let(:resource_class) { Collection::Library }

  it_behaves_like 'a collection controller'
end
