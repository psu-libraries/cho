# frozen_string_literal: true

RSpec::Matchers.define :have_blacklight_field do |field|
  match do |_actual|
    within('dd.blacklight-' + field) do
      page.has_content(value)
    end
  end

  chain :with do |value|
    @value = value
  end
end

RSpec::Matchers.define :have_blacklight_label do |field|
  match do |_actual|
    within('dt.blacklight-' + field) do
      page.has_content(value)
    end
  end

  chain :with do |value|
    @value = value
  end
end
