# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent, type: :feature do
  before do
    create :agent
    visit agent_resources_path
  end

  def t(key)
    I18n.t "cho.agent.index.#{key}"
  end

  context 'when the current user is an admin' do
    it 'shows the CRUD links on the index page' do
      expect(page).to have_link t('edit')
      expect(page).to have_link t('destroy')
      expect(page).to have_link t('new')
    end
  end

  context 'when the current user is a PSU user but not an admin', :with_psu_user do
    it 'does not show CRUD links on the index page' do
      expect(page).not_to have_link t('edit')
      expect(page).not_to have_link t('destroy')
      expect(page).not_to have_link t('new')
    end
  end

  context 'when the current user is a member of the public', :with_public_user do
    it 'does not show CRUD links on the index page' do
      expect(page).not_to have_link t('edit')
      expect(page).not_to have_link t('destroy')
      expect(page).not_to have_link t('new')
    end
  end
end
