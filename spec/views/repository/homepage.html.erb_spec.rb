# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'repository/home/index', type: :view do
  let(:blacklight_config) { Blacklight::Configuration.new }

  before do
    view.class.send(:attr_reader, :blacklight_config)
    assign(:blacklight_config, blacklight_config)
  end

  it 'displays the title, browse, and featured on the home page' do
    allow(view).to receive(:render).and_call_original
    expect(view).to receive(:render).with(partial: 'shared/search_bar').and_return('search_bar')
    render
    expect(rendered).to have_selector('h1#home-title')
    expect(rendered).not_to have_selector('span.translation_missing')

    expect(rendered).to have_selector('div#home-browse-by')
    expect(rendered).to have_selector('div#home-browse-by h2#home-browse-by-title')
    expect(rendered).to have_css('div#home-browse-by figure.home-figure',
                                 text: I18n.t('cho.home.browse_by.resource'))
    expect(rendered).to have_css('div#home-browse-by figure.home-figure',
                                 text: I18n.t('cho.home.browse_by.collection'))

    expect(rendered).to have_selector('h2#home-featured')
    expect(rendered).to have_css('figure.home-figure', count: 4)
  end
end
