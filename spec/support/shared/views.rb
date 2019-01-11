# frozen_string_literal: true

RSpec.shared_examples 'a creator form' do
  it 'renders the new form' do
    assert_select 'input[name=?]', "#{resource.model_name.param_key}[creator][agent]"
    assert_select 'input[name=?]', "#{resource.model_name.param_key}[creator][role]"

    if creator_hash.present?
      assert_select 'input[value=?]', agent1.id.to_s
      assert_select 'input[value=?]', MockRDF.relators.first.to_uri.to_s
    end

    assert_select 'datalist[id=?]', 'creator_role'
    assert_select 'option[value=?]', '/vocabulary/relators/bsl'
    assert_select 'option', 'blasting'
    assert_select 'option[value=?]', '/vocabulary/relators/cli'
    assert_select 'option', 'climbing'

    assert_select 'datalist[id=?]', 'creator_agent'
    assert_select 'option[value=?]', agent1.id.to_s
    assert_select 'option', 'Jane Doe'
    assert_select 'option[value=?]', agent2.id.to_s
    assert_select 'option', 'John Doe'
  end
end
