# frozen_string_literal: true

RSpec::Matchers.define :have_blacklight_field do |field|
  match do |_actual|
    page.has_selector?("dd.blacklight-#{field}", text: @value)
  end

  chain :with do |value|
    @value = value
  end
end

RSpec::Matchers.define :have_blacklight_label do |field|
  match do |_actual|
    page.has_selector?("dt.blacklight-#{field}", text: @value)
  end

  chain :with do |value|
    @value = value
  end
end
