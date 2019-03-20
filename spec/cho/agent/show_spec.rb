# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent, type: :feature do
  let(:agent) { create :agent }

  before { visit(agent_resource_path(agent)) }

  def t(key)
    I18n.t "cho.agent.index.#{key}"
  end

  context 'when the current user is an admin' do
    specify { expect(page).to have_link t('edit') }
  end

  context 'when the current user is a PSU user but not an admin', :with_psu_user do
    specify { expect(page).not_to have_link t('edit') }
  end
end
