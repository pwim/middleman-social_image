require "capybara"
Capybara.server = :webrick
Capybara.register_driver :selenium_chrome_headless do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << '--headless'
    opts.args << '--disable-gpu' if Gem.win_platform?
    opts.args << '--disable-site-isolation-trials'
    opts.args << '--hide-scrollbars'
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end
