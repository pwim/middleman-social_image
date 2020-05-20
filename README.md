# Middleman::SocialImage

Use HTML and CSS to dynamically generate static images for Open Graph (Facebook, LinkedIn) and Twitter cards in a Middleman application. Image is generated by using Google Chrome in headless mode to screenshot a page served by middleman. Originally created for [tokyodev](https://www.tokyodev.com/), which lists internationally-friendly software developer jobs in Japan.

## Installation

Add this line to your application's Gemfile:

    gem 'middleman-social_image'

And then execute:

    $ bundle

## Usage

You need to add the following code to your ```config.rb``` file:

```ruby
activate :social_image
```

Optionally, you can configure this extension with the following (defaults are shown):

```ruby
activate :social_image do |social_image|
  social_image.window_size = '1200,600' # The size of the screenshot
  social_image.base_asset_dir = 'assets/images/social-images' # Where to save the generated images
  social_image.social_image_url_pattern = %r{(/social-image)/$}  # Screenshot URLs matching this pattern
  social_image.social_image_url_substitution = '\1.png' # When generating screenshots, replace URLs matching social_image_url_pattern with this
  social_image.selector = 'body > *' # Used to test that the social image url has loaded properly. The more specific this is, the better the chance of catching errors.
end
```

Create a HTML page in your middleman app that contains the HTML you want to be rendered. The URL for this should match the social_image_url_pattern (so by default, ending with `/social-image/`).

Start up the middleman server with `bundle exec middleman server`

Run the `bundle exec middleman social_image` command to generate images from any URLs matching social_image_url_pattern. The image will be saved to a location matching the URL of the resource used to generate it, with the social_image_url_substitution applied, in the base_asset_dir. So with the default settings, if for instance you had created a page at `/examples/social-image/`, this image would be saved at `assets/images/social-images/examples/social-image.png`.

You can now refer to this image as normal within your middleman application.
