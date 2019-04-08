# frozen_string_literal: true

class MetadataFactory
  # Generates an academic-like title with a variety of punctuation using lorem text.
  # @example
  #  Et: "unde, odio, nihil; dolorum's vero's animi"
  def self.fancy_title
    "#{Faker::Lorem.words(rand(1..5)).join(' ').capitalize}: " \
    "\"#{Faker::Lorem.words.join(', ')}; #{Faker::Lorem.words.join("'s ")}\""
  end

  def self.collection_attributes
    {
      title: Faker::Company.name,
      subtitle: fancy_title,
      description: Faker::Lorem.paragraph,
      alternate_ids: Faker::Number.leading_zero_number(10),
      generic_field: Faker::Hipster.sentence,
      created: Faker::Date.between(2.years.ago, Date.today)
    }
  end
end
