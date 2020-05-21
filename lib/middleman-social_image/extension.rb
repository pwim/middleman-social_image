require 'middleman-core'

class Middleman::SocialImage::Extension < ::Middleman::Extension
  option :window_size, '1200,600'
  option :selector, "body > *"
  option :always_generate, true

  def initialize(app, options_hash={}, &block)
    super
    require "middleman-social_image/converter"
    require "middleman-social_image/resource"
    @converter = Middleman::SocialImage::Converter.new(app, options.window_size, options.selector, options.always_generate)
  end

  def before_build(builder)
    build_resource = proc do |resource|
      @converter.convert(resource)
    end
    if builder.instance_variable_get(:@parallel)
      ::Parallel.each(social_image_resources, &build_resource)
    else
      social_image_resources.each(&build_resource)
    end
  end

  def manipulate_resource_list(resources)
    resources + social_image_resources.map do |resource|
      path = resource.path.sub(".html", ".png")
      if app.build?
        Middleman::Sitemap::Resource.new(
          @app.sitemap,
          path,
          @converter.image_path(resource)
        )
      else
        Middleman::SocialImage::Resource.new(
          @app.sitemap,
          path,
          @converter,
          resource
        )
      end
    end
  end

  private

  def social_image_resources
    app.sitemap.resources.select {|resource| resource.options[:social_image] || resource.data[:social_image] }
  end
end
