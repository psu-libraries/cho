# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('tmp', prefix: 'uploads/cache'), # temporary
  store: Shrine::Storage::FileSystem.new('tmp', prefix: 'uploads/store'), # permanent
}

Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :rack_file # for non-Rails apps
