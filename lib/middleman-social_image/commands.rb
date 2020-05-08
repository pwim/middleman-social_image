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
        app = ::Middleman::Application.new do
          config[:mode]              = :config
          config[:watcher_disable]   = true
        end
        options = app.extensions[:social_image].options
        app.sitemap.resources.each do |resource|
          if resource.url =~ options.social_image_url_pattern
            image_path = File.join(app.source_dir, options.base_asset_dir, resource.url.sub(options.social_image_url_pattern, options.social_image_url_substitution))
            if File.exists?(image_path)
              say "Image for #{resource.url} already generated, skipping."
            else
              FileUtils.mkdir_p(File.dirname(image_path))
              url = File.join(options.base_url, resource.url)
              run "#{options.path_to_chrome}  --headless --disable-gpu --screenshot=#{image_path} --window-size=#{options.window_size} #{url}"
            end
          end
        end
      end
    end

    Base.register(Middleman::Cli::SocialImage, 'social_image', 'social_image [options]', 'Generates social images.')
  end
end
