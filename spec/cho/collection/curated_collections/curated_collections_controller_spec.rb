# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::CuratedCollectionsController, type: :controller do
  let(:collection) { create_for_repository(:curated_collection) }
  let(:resource_class) { Collection::Curated }

  it_behaves_like 'a collection controller'
end
