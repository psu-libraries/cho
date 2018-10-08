# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.rm_rf(ImportFactory::Bag.root)
    Rails.root.join('tmp').children.each do |file|
      file.unlink if file.basename.to_s.match?(/_extracted_text_/)
    end
  end
end
