require 'middleman-core'
require 'middleman-social_image/commands'

class Middleman::SocialImage::Extension < ::Middleman::Extension
  option :window_size, '1200,600'
  option :base_url, 'http://localhost:4567/'
  option :base_asset_dir, 'assets/images/social-images'
  option :social_image_url_pattern, %r{(/social-image)/$}
  option :social_image_url_substitution, '\1.png'
end
