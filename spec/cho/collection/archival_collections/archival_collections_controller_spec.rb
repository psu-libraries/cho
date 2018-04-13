# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::ArchivalCollectionsController, type: :controller do
  let(:collection) { create(:archival_collection) }
  let(:resource_class) { Collection::Archival }

  it_behaves_like 'a collection controller'
end
