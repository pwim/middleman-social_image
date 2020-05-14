require 'middleman-core'
require 'middleman-social_image/commands'

class Middleman::SocialImage::Extension < ::Middleman::Extension
  option :window_size, '1200,600'
  option :port, 4444
  option :base_asset_dir, 'assets/images/social-images'
  option :social_image_url_pattern, %r{(/social-image)/$}
  option :social_image_url_substitution, '\1.png'
  option :selector, "body > *"
end
