# frozen_string_literal: true

# @note Class used for mocking sets of RDF terms that are usually very large and can take a long time
#       to initially load. By mocking them, we can reduce testing time.
class MockRDF
  def self.relators
    [
      RDF::Vocabulary::Term.new('http://id.loc.gov/vocabulary/relators/bsl', attributes: { label: 'blasting' }),
      RDF::Vocabulary::Term.new('http://id.loc.gov/vocabulary/relators/cli', attributes: { label: 'climbing' })
    ]
  end
end

RSpec.configure do |config|
  config.before do
    allow(RDF::Vocab::MARCRelators).to receive(:to_a).and_return(MockRDF.relators)
  end
end
