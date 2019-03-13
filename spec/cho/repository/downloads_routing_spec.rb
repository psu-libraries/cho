# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::DownloadsController, type: :routing do
  describe 'routing' do
    it 'has a route to #download' do
      expect(get: '/downloads/1').to route_to('repository/downloads#download', id: '1')
    end
  end
end
