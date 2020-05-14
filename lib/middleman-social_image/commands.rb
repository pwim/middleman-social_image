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
        require "capybara"
        app = ::Middleman::Application.new do
          config[:mode]              = :config
          config[:watcher_disable]   = true
        end
        options = app.extensions[:social_image].options
        Capybara.register_driver :selenium_chrome_headless do |app|
          Capybara::Selenium::Driver.load_selenium
          browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
            opts.args << "--window-size=#{options.window_size}"
            opts.args << '--headless'
            opts.args << '--disable-gpu' if Gem.win_platform?
            opts.args << '--disable-site-isolation-trials'
            opts.args << '--hide-scrollbars'
          end
          Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
        end
        session = Capybara::Session.new(:selenium_chrome_headless)

        app.sitemap.resources.each do |resource|
          if resource.url =~ options.social_image_url_pattern
            image_path = File.join(app.source_dir, options.base_asset_dir, resource.url.sub(options.social_image_url_pattern, options.social_image_url_substitution))
            if File.exists?(image_path)
              say "Skipping #{image_path} as already generated"
            else
              say "Generating #{image_path}"
              FileUtils.mkdir_p(File.dirname(image_path))
              url = File.join(options.base_url, resource.url)
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
