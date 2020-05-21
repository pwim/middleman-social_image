require 'middleman-core'

class Middleman::SocialImage::Extension < ::Middleman::Extension
  option :window_size, '1200,600'
  option :selector, "body > *"
  option :always_generate, true
  option :parallel, true

  def initialize(app, options_hash={}, &block)
    super
    require "middleman-social_image/converter"
    require "middleman-social_image/resource"
    @converter = Middleman::SocialImage::Converter.new(app, options.window_size, options.selector, options.always_generate)
  end

  def manipulate_resource_list(resources)
    if app.build?
      manipulate_resource_list_for_build(resources)
    else
      manipulate_resource_list_for_preview(resources)
    end
  end

  private

  def social_image_source_resources
    app.sitemap.resources.select {|resource| resource.options[:social_image] || resource.data[:social_image] }
  end

  def path_for_source_resource(resource)
    resource.path.sub(".html", ".png")
  end

  def manipulate_resource_list_for_build(resources)
    convert_resource = proc do |resource|
      @converter.convert(resource)
    end
    if options.parallel
      ::Parallel.each(social_image_source_resources, &convert_resource)
    else
      social_image_source_resources.each(&convert_resource)
    end
    social_image_resources = social_image_source_resources.map do |resource|
      Middleman::Sitemap::Resource.new(
        @app.sitemap,
        path_for_source_resource(resource),
        @converter.image_path(resource)
      )
    end
    resources + social_image_resources - social_image_source_resources
  end

  def manipulate_resource_list_for_preview(resources)
    resources + social_image_source_resources.map do |resource|
      Middleman::SocialImage::Resource.new(
        @app.sitemap,
        path_for_source_resource(resource),
        @converter,
        resource
      )
    end
  end
end
