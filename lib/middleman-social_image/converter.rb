require "middleman-social_image/capybara"
class Middleman::SocialImage::Converter
  def initialize(app, window_size, selector, base_url)
    @app = app
    @window_size = window_size
    @selector = selector
    @base_url = base_url
  end

  def image_path(resource)
    File.join(@app.root, "tmp/middleman-social_image", resource.path.sub(".html", ".png"))
  end

  def convert(resource)
    image_path = image_path(resource)
    @app.logger.debug "== social_image: converting #{resource.path}"
    session.visit(File.join(@base_url, resource.url))
    raise "#{resource.url} did not contain '#{@selector}'." unless session.has_selector?(@selector)
    FileUtils.mkdir_p(File.dirname(image_path))
    session.save_screenshot(image_path)
  end

  private

  def session
    @session ||= begin
      if @app.server?
        rack_app = ::Middleman::Rack.new(@app).to_app
        session = Capybara::Session.new(:selenium_chrome_headless, rack_app)
      else
        session = Capybara::Session.new(:selenium_chrome_headless)
      end
      session.current_window.resize_to(*@window_size.split(","))
      session
    end
  end
end
