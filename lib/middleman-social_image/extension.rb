require 'middleman-core'
require 'middleman-social_image/commands'
require "middleman-social_image/resource"

class Middleman::SocialImage::Extension < ::Middleman::Extension
  option :window_size, '1200,600'
  option :base_asset_dir, 'assets/images/social-images'
  option :social_image_path_pattern, %r{social-image.html$}
  option :social_image_path_substitution, 'social-image.png'
  option :selector, "body > *"

  def initialize(app, options_hash={}, &block)
    super
    require "middleman-social_image/converter"
    @converter = Middleman::SocialImage::Converter.new(app, options.window_size)
  end

  def manipulate_resource_list(resources)
    social_image_sources = resources.
      select {|resource| resource.path =~ options.social_image_path_pattern}
    social_image_resources = social_image_sources.map do |resource|
      path = resource.path.sub(options.social_image_path_pattern, options.social_image_path_substitution)
      Middleman::SocialImage::Resource.new(
        @app.sitemap,
        path,
        @converter,
        resource
      )
    end
    resources + social_image_resources
  end
end
