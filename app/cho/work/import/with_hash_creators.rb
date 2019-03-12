# frozen_string_literal: true

module Work::Import::WithHashCreators
  def agents_with_roles
    Array.wrap(resource_hash['creator']).map do |creator|
      fullname, role = creator.split(CsvParsing::SUBVALUE_SEPARATOR)
      {
        role: find_role(role),
        agent: find_agent(fullname)
      }
    end
  end

  def find_agent(name)
    surname, given_name = name.split(Agent::Resource::NAME_SEPARATOR)
    result = Agent::Resource.where(given_name: given_name.strip, surname: surname.strip).first
    if result
      result.id.to_s
    else
      name
    end
  end

  def find_role(role)
    return if role.blank?
    RDF::URI("http://id.loc.gov/vocabulary/relators/#{role}")
  end
end
