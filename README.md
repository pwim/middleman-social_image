# Middleman::SocialImage

Use HTML and CSS to generate images when building your Middleman site. The intended use case is for generating images for use with [the Open Graph protocol](https://ogp.me/), which will be included when someone shares your page on Facebook, Twitter, etc.

Example of an image generated with this extension:

![](https://www.tokyodev.com/2020/05/29/generating-social-images-with-static-site-generators/social-image-714b5c6e.png)

For more background, see [generating social images with static site generators](https://www.tokyodev.com/2020/05/29/generating-social-images-with-static-site-generators/).

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
  social_image.selector = 'body > *' # Used to test that the social image url has loaded properly. The more specific this is, the better the chance of catching errors.
  social_image.parallel = true # Generate images in parallel.
  social_image.base_url = "http://localhost:4567/" # When building the site, fetch against this URL.
end
```

Create a HTML page in your middleman app that contains the HTML you want to be rendered. Add `social_image: true` to the page's front matter to indicate it is the source for a social image. You can also add it as an option if you're using a proxy page like the following.

``` ruby
["tom", "dick", "harry"].each do |name|
  proxy "/social-image/#{name}.html", "/templates/social-image.html", social_image: true, locals: { name: name }
end
```

You can now refer to this image as normal within your middleman application.

In preview mode, you don't need any other special setup. However, to generate the images in build, you also need to be running the preview server. While you can use `bundle exec middleman server`, using a concurrent server like puma can speed up the generation incredibly. To do this, you'll need to [create a config.ru file](https://middlemanapp.com/basics/start-new-site/#config-ru).
