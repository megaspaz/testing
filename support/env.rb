require 'active_support/core_ext/string/inflections'
require 'rspec/matchers'
require 'colored'
require 'rbconfig'
require 'selenium-webdriver'
require 'yaml'
require_relative './os_sniffer'
require_relative './selenium_driver'
require_relative './to_bool'

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
    time_now = Time.now.to_i
    begin
      filename = "html_dump-#{time_now}.txt"
      full_path = File.join(Dir.pwd, 'results', filename)
      File.open(full_path, 'w') { |file| file.write($driver.page_source) }
      embed(filename, "text/html", '<br />HTML Dump<br />')
    rescue Exception => e
      puts "Failed to embed HTML dump."
      puts e.message
      e.backtrace.each { |l| puts l }
    end

    begin
      browser_os = "#{ENV['SELENIUM_BROWSER'].capitalize}/#{ENV['OS'].capitalize} OS"
      encoded_img = $driver.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}",'image/png', "<br />Screenshot (#{browser_os})<br />")
    rescue Exception => e
      puts "Failed to capture screenshot.\nException:\n#{e}"
    end
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
