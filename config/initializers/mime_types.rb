# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

# jp2 does not have a friendly name. I'm not sure if this is the best place to
# provide that, but it seems better than nothing.
#
# Also note that `Mime` and `MIME` are different constants, one provided by
# Rails and the other provided by the mime-types gem.
require 'mime-types'
MIME::Types.of('jp2').each do |t|
  t.friendly 'en' => 'JPEG 2000 Image'
end
