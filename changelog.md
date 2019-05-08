# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2019-06-21
### Added
### Changed
### Fixed

## [v0.6.0](https://github.com/psu-libraries/cho/releases/tag/v0.6.0) - 2019-04-12
### Added
- File set metadata can be edited in the GUI, but files cannot be added or deleted.
- File sets can be individually deleted in the GUI and receive the user must confirm the action.
- If no thumbnail is included in the representative file set, the first thumbnail found in the first file set is used as the representative thumbnail for the resource.
- Create agent form.
- Files can be downloaded from the resource landing page (representative and plain text) and file set landing pages (preservation/preservation_redacted, service, plain text, and access). If a redacted preservation file is present, the master preservation file is unavailable for download. Images are also embedded for display.
- Public (not logged in) and PSU (logged in, but no privileges) user roles have been added, in addition to the existing administrative user role. (While in MVP, it's still required to be on the PSU Network to access CHO.)
- Creators can be assigned a role, such as photographer or architect.
- UTF-8 character-encoding is enforced, and non UTF-8 characters are pasted into the GUI, a message is displayed to the user showing their input with poop emojis replacing the non-UTF-8 characters so the user knows what needs to be replaced.
- A new homepage has been added.
- Resources are ordered in their home collection in the order they appear/were imported in CSVs or are imported into the GUI.
- Gallery view added to catalog.
### Changed
- Upgraded to Bootstrap 4.3.1.
- Upgraded to Blacklight 7.0.1
- When importing a bag, any existing bag in the staging directory with the same name is deleted. The bag being imported is deleted after the import process, whether or not it was successful.
- CSV metadata now includes file set metadata, is roundtrip-able, and `work_type` is case insensitive.
- `date_created` is now an EDTF date field and `rights_statement` is a facet.
- `member_of_collection_ids` is now called `home_collection_id` in the data dictionary.
- `narrative` and `acknowledgements` fields added to data dictionary and collection schema for use on collection landing pages.
- Various tweaks to UI labels, including changing "work" to "resource".
- Adding and deleting files has been disabled in the GUI. (For now.)
- Metadata edit forms have been enhanced for repeatability.
- Improved styling to headers, links, and labels to reduce confusion.
### Fixed
- CSV files encoded as UTF-8 with BOM (Byte Order Mark), as exported by MS Excel, now import correctly.
- `batch_id` validation no longer requires a YYYY-MM-DD date.
- Representative file sets require an access file, not a service file, and cannot include preservation files.
- Resources that use a PSU Identifier (as opposed to a Valkyrie ID) as a `member_of_collection_ids` (now called `home_collection_id`) now associate with the correct collection.
- Agent metadata is displayed correctly during the agent CSV import process.
- Duplicate identifiers are not allowed.
- Filenames and identifiers are indexing correctly.
- Show link on metadata edit form now routes correctly.

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
- Unreleased: https://github.com/psu-libraries/cho/compare/v0.6.0...HEAD
- v0.6.0: https://github.com/psu-libraries/cho/compare/v0.5.0...v0.6.0
- v0.5.0: https://github.com/psu-libraries/cho/compare/v0.4.0...v0.5.0
- v0.4.0: https://github.com/psu-libraries/cho/compare/v0.3.0...v0.4.0
- v0.3.0: https://github.com/psu-libraries/cho/compare/v0.2.0...v0.3.0
- v0.2.0: https://github.com/psu-libraries/cho/compare/v0.1.0...v0.2.0
