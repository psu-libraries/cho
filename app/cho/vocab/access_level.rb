# frozen_string_literal: true

require 'rdf'

# @note this is a placeholder until a better ontology is made
module Vocab
  class AccessLevel < RDF::StrictVocabulary('https://libraries.psu.edu/access_level#')
    # Ontology definition
    ontology :"https://libraries.psu.edu/access_level#",
             comment: %(Local ontology of access levels used to control access to resources in CHO.),
             "dc:title": %(CHO Access Level)

    # Class definitions
    term :Public,
         comment: %(Resource is available to anyone.),
         label: 'Public',
         # "rdf:subClassOf": %(???),
         "rdfs:isDefinedBy": %(choaccess:),
         type: 'rdfs:Class'

    term :PennState,
         comment: %(Resource is available to anyone authenticated as a member of Penn State.),
         label: 'PSU Access',
         # "rdf:subClassOf": %(???),
         "rdfs:isDefinedBy": %(choaccess:),
         type: 'rdfs:Class'

    term :Restricted,
         comment: %(Resource is restricted to select individuals and groups.),
         label: 'Restricted',
         # "rdf:subClassOf": %(???),
         "rdfs:isDefinedBy": %(choaccess:),
         type: 'rdfs:Class'
  end
end
