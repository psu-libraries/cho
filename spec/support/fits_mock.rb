# frozen_string_literal: true

def mock_fits(output = nil)
  allow(Hydra::FileCharacterization)
    .to receive(:characterize)
    .and_return(output || mock_fits_output)
end

def mock_fits_output
  @mock_fits_output ||= File.read(
    Pathname.new(fixture_path).join('fits_output.xml')
  )
end

RSpec.configure do |config|
  config.before do |example|
    mock_fits if ENV['TRAVIS'] || !example.metadata.key?(:with_fits)
  end
end
