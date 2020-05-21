require "middleman-social_image/capybara"
class Middleman::SocialImage::Converter
  def initialize(app, window_size, selector)
    @app = app
    @window_size = window_size
    @selector = selector
  end

  def image_path(resource)
    File.join(@app.root, "tmp/middleman-social_image", @app.config[:mode].to_s, resource.path.sub(".html", ".png"))
  end

  def convert(resource)
    session.visit(resource.url)
    raise "#{url} did not contain '#{@selector}'." unless session.has_selector?(@selector)
    image_path = image_path(resource)
    FileUtils.mkdir_p(File.dirname(image_path))
    session.save_screenshot(image_path)
  end

  private

  def session
    @session ||= begin
      rack_app = ::Middleman::Rack.new(@app).to_app
      Capybara::Session.new(:selenium_chrome_headless, rack_app).tap do |session|
        session.current_window.resize_to(*@window_size.split(","))
      end
    end
  end
end
