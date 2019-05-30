# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_footer', type: :view do
  before do
    Rails.root.join('REVISION').write('1234567')
    render
  end

  after do
    Rails.root.join('REVISION').delete
  end

  it 'displays the link to the commit in the footer' do
    expect(rendered).to have_content '1234567'
  end
end
