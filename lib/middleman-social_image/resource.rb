class Middleman::SocialImage::Resource < ::Middleman::Sitemap::Resource
  def initialize(store, path, converter, base_resource)
    super(store, path)
    @converter = converter
    @base_resource = base_resource
  end

  def render(*)
    @converter.convert(@base_resource)
  end
end
