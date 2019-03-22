# frozen_string_literal: true

require 'rdf'

# @note this is extending from the PCDM use ontology. All URIs and namespaces are fake right now until
#   we can decide how to define our own ontologies.
module Vocab
  class FileUse < RDF::StrictVocabulary('https://libraries.psu.edu/use#')
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
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
    term :ExtractedText,
         comment: %(A textual representation of the Object appropriate for fulltext indexing,
                    such as a plaintext version of a document, or OCR text.),
         label: 'access file',
         "rdf:subClassOf": %(http://pcdm.org/use#ExtractedText),
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
    term :PreservationMasterFile,
         comment: %(Best quality representation of the Object appropriate for long-term
                    preservation.),
         label: 'preservation master file',
         "rdf:subClassOf": %(http://pcdm.org/resources#PreservationMasterFile),
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
    term :ServiceFile,
         comment: %(A medium quality representation of the Object appropriate for serving to
                    users.  Similar to a FADGI "derivative file" but can also be used for born-digital content,
                    and is not necessarily derived from another file.),
         label: 'service file',
         "rdf:subClassOf": %(http://pcdm.org/resources#ServiceFile),
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
    term :ThumbnailImage,
         comment: %(A low resolution image representation of the Object appropriate for using as an icon.),
         label: 'thumbnail image',
         "rdf:subClassOf": %(http://pcdm.org/resources#ThumbnailImage),
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
    term :FrontImage,
         comment: %(Front image.),
         label: 'front image',
         "rdf:subClassOf": %(http://pcdm.org/resources#ServiceFile),
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
    term :BackImage,
         comment: %(Back image.),
         label: 'front image',
         "rdf:subClassOf": %(http://pcdm.org/resources#ServiceFile),
         "rdfs:isDefinedBy": %(chouse:),
         type: 'rdfs:Class'
  end
end
