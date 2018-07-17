require 'active_support/core_ext/string/inflections'
require 'rspec/matchers'
require 'colored'
require 'rbconfig'
require 'require_all'
require 'selenium-webdriver'
require 'yaml'
require_rel '../lib/*.rb'

ENV['OS'] = OsSniffer.get_local_os
ENV['SELENIUM_BROWSER'] ||= 'firefox'
ENV['DEBUG_MODE'] ||= 'false'
ENV['VIEW_IMPL'] ||= 'desktop_web'

if ENV['VIEW_IMPL'] =~ /^(desktop|mobile|tablet)_web$/
  SeleniumDriver.get_driver
end

# Take a screenshot on fail.
After('@desktop_web or @mobile_web or @tablet_web') do |scenario|
  if scenario.failed?
    embed_html
    embed_screenshot
  else
    embed_browser_os
  end
end

at_exit do
  case ENV['VIEW_IMPL']
  when /^(desktop|mobile|tablet)_web$/
    if !ENV['DEBUG_MODE'].to_bool
      puts Colored.colorize(
        'Safari requires manually quitting the browser...').bold.yellow if ENV['SELENIUM_BROWSER'] == 'safari'
      $driver&.quit
      $service&.stop if ENV['SELENIUM_BROWSER'] == 'opera'
    elsif ENV['DEBUG_MODE'].to_bool && ENV['SELENIUM_BROWSER'] =~ /(chrome|opera|safari)$/
      puts Colored.colorize(
        "Chromium based drivers quit the browser before our at_exit call. Using `detach: true` also did not work.\n" +
          "Browser is always killed -> https://github.com/SeleniumHQ/selenium/issues/742\n" +
          "Safari does not work for some other reason...").bold.yellow
    end
  end
end
