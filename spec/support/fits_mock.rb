# frozen_string_literal: true

def mock_fits_for_travis(output = nil)
  mock_fits(output) if ENV['TRAVIS']
end

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
