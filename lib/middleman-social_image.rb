require "middleman-core"
require 'middleman-social_image/version'

Middleman::Extensions.register :social_image do
  require "middleman-social_image/extension"
  Middleman::SocialImage::Extension
end
