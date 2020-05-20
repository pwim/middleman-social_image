require 'middleman-cli'

module Middleman
  module Cli
    class SocialImage < Thor::Group
      include Thor::Actions

      check_unknown_options!

      namespace :social_image

      def self.exit_on_failure?
        true
      end

      def social_image
        require "middleman-social_image/capybara"
        app = ::Middleman::Application.new do
          config[:mode]              = :config
          config[:watcher_disable]   = true
        end
        options = app.extensions[:social_image].options

        rack_app = ::Middleman::Rack.new(app).to_app
        server = Capybara::Server.new(rack_app)
        server.boot
        session = Capybara::Session.new(:selenium_chrome_headless)
        session.current_window.resize_to(*options.window_size.split(","))
        app.sitemap.resources.each do |resource|
          if resource.url =~ options.social_image_url_pattern
            image_path = File.join(app.source_dir, options.base_asset_dir, resource.url.sub(options.social_image_url_pattern, options.social_image_url_substitution))
            if File.exists?(image_path)
              say "Skipping #{image_path} as already generated"
            else
              say "Generating #{image_path}"
              FileUtils.mkdir_p(File.dirname(image_path))
              url = File.join(server.base_url, resource.url)
              session.visit(url)
              if session.has_selector?(options.selector)
                session.save_screenshot(image_path)
              else
                say "Aborting. #{image_path} did not contain '#{options.selector}'. Is the preview server running?"
                exit
              end
            end
          end
        end
      end
    end

    Base.register(Middleman::Cli::SocialImage, 'social_image', 'social_image [options]', 'Generates social images.')
  end
end
