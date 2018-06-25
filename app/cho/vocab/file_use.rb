# frozen_string_literal: true

require 'rdf'

# @note this is extending from the PCDM use ontology. All URIs and namespaces are fake right now until
#   we can decide how to define our own ontologies.
module Vocab
  class FileUse < RDF::Vocabulary('https://libraries.psu.edu/use#')
    # Ontology definition
    ontology :"https://libraries.psu.edu/use#",
             comment: %(Ontology for a local ontology of file rotes that extends the PCDM use ontology to add
                        subclasses of PCDM File for the different roles files have in relation to the Object
                        they are attached to.),
             "dc:title": %(CHO File Use)

    # Class definitions
    term :RedactedPreservationMasterFile,
         comment: %(Best quality representation of the Object with sensitive information redacted for security.
                    Appropriate for long-term preservation.),
         label: 'redacted preservation master file',
         "rdf:subClassOf": %(http://pcdm.org/use#PreservationMasterFile),
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
    term :AccessFile,
         comment: %(A medium quality representation of the Object appropriate for serving to users
                    generated automatically from a higher-quality source.),
         label: 'access file',
         "rdf:subClassOf": %(http://pcdm.org/use#ServiceFile),
         "rdfs:isDefinedBy": %(chomuse:),
         type: 'rdfs:Class'
  end
end
