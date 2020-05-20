require 'middleman-core'

class Middleman::SocialImage::Extension < ::Middleman::Extension
  option :window_size, '1200,600'
  option :selector, "body > *"

  def initialize(app, options_hash={}, &block)
    super
    require "middleman-social_image/converter"
    require "middleman-social_image/resource"
    @converter = Middleman::SocialImage::Converter.new(app, options.window_size, options.selector)
  end

  def manipulate_resource_list(resources)
    resources + resources.
      select {|resource| resource.options[:social_image] }.
      map do |resource|
        path = resource.path.sub(".html", ".png")
        Middleman::SocialImage::Resource.new(
          @app.sitemap,
          path,
          @converter,
          resource
        )
      end
  end
end
