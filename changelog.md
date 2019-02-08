# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2019-04-29
### Added
### Changed
### Fixed

## [v0.5.0](https://github.com/psu-libraries/cho/releases/tag/v0.5.0) - 2019-01-11
### Added
- Agent records for creators, contributors and other controlled fields. Agents can be added via a form in the GUI or in bulk via CSV.
- Subform for agents on metadata edit forms allowing value-pairs for related metadata, e.g. MARC relators for creators.
- Data dictionary linked-field type for controlled vocabularies
### Changed
- Confirmation process for deleting collections and works
- Thumbnails displayed in search results and on file set landing page
- Facets include result count
### Fixed
- Tests generate correct type of random content

## [v0.4.0](https://github.com/psu-libraries/cho/releases/tag/v0.4.0) - 2018-10-26
### Added
- Matomo web analytics in basic implementation
- Footer with linked tag of the deployed release in production
- Dates can be stored as ETDF dates, work ticketed for indexing and display improvements
- Export collection metadata, including fileset metadata as CSV
- Page for file sets

### Changed
- Edit form has been standardized to look and operate in a standardized and repeatable way
- Batch creation of works (CSV) now includes fileset metadata, batch update still does not
- Configure facets with the data dictionary
- Files with machine-extractable text are indexed (not OCR), text stored as new file in fileset
- Filenames are indexed

### Fixed
- Both archival and library collections now show up in the create dropdown menu.
- Improved error messaging during creation workflow
- Removed files and file sets from manage works batch selection

## [v0.3.0](https://github.com/psu-libraries/cho/releases/tag/v0.3.0) - 2018-09-08
### Added
- Batch creation of works (CSV) with files; files are bagged and stagged on the CHO web server.
- Files are organized into file sets and classified by usage (preservation, preservation redacted, service, access, thumb)
- Files are characterized by FITS by output is a blob, not currently parsed

### Changed
- Accessibility improvements

### Fixed
- Bug fixes

## [v0.2.0](https://github.com/psu-libraries/cho/releases/tag/v0.2.0) - 2018-06-04
### Added
- Files can be attached to works and stored, but not downloaded
- Batch creation of works by uploading a CSV with metadata, no files
- Batch update of work metadata by uploading a CSV
- Delete works, individually and in batch
- Facets for collections
- Atomic indexing

## [v0.1.0](https://github.com/psu-libraries/cho/releases/tag/v0.1.0) - 2017-10-27
### Added
- Rails web server
- Blacklight Solr discovery interface for indexing, searching, and browsing of resources and collections
- Valkyrie for storing metadata and files in Samvera
- Forms for creating and describing archival and library collections and multiple work types
- Pages for collections and works
- Metadata defined by a data dictionary, with schemas for work types
- Authentication using Penn States's Shibboleth

## Code Diffs
- Unreleased: https://github.com/psu-libraries/cho/compare/v0.5.0...HEAD
- v0.4.0: https://github.com/psu-libraries/cho/compare/v0.4.0...v0.5.0
- v0.4.0: https://github.com/psu-libraries/cho/compare/v0.3.0...v0.4.0
- v0.3.0: https://github.com/psu-libraries/cho/compare/v0.2.0...v0.3.0
- v0.2.0: https://github.com/psu-libraries/cho/compare/v0.1.0...v0.2.0
