# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_footer', type: :view do
  before do
    Rails.root.join('REVISION').write('current_commit')
    render
  end

  after do
    Rails.root.join('REVISION').delete
  end

  it 'displays the link to the commit in the footer' do
    expect(rendered).to have_content 'current_commit'
  end
end
