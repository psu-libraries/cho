# frozen_string_literal: true

# @note
#   Specifies the solr field names of permissions-related fields.
#   Field names must correspond to those in solrconfig.xml and  Valkyrie::Indexers::AccessControlsIndexer.
#   Currently, discover and download permissions are considered the same as read permissions.
Blacklight::AccessControls.configure do |config|
  config.discover_group_field = 'read_access_group_ssim'
  config.discover_user_field  = 'read_access_person_ssim'
  config.read_group_field     = 'read_access_group_ssim'
  config.read_user_field      = 'read_access_person_ssim'
  config.download_group_field = 'read_access_group_ssim'
  config.download_user_field  = 'read_access_person_ssim'

  # Specify the user model for obtaining group memberships
  # config.user_model = 'User'
end
