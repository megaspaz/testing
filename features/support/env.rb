require 'rbconfig'
require 'selenium-webdriver'

module OsSniffer
  include RbConfig
  def self.get_local_os
    STDOUT.puts "Determining host operating system... #{RbConfig::CONFIG['host_os']}"

    case RbConfig::CONFIG['host_os']
    when /mswin|windows/i
      return "win"
    when /linux|arch/i
      return "linux"
    when /sunos|solaris/i
      return "sun"
    when /darwin/i
      return "mac"
    else
      return nil
    end
  end
end

ENV['OS'] = OsSniffer.get_local_os
ENV['SELENIUM_BROWSER'] ||= 'firefox'

if ENV['SELENIUM_BROWSER'] == 'chrome'
  # Set options and driver to chrome.
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-translate')
  $driver = Selenium::WebDriver.for :chrome, options: options
elsif ENV['SELENIUM_BROWSER'] == 'opera'
  @service = Selenium::WebDriver::Chrome::Service.new('/usr/bin/operadriver', 12345, {})
  @service.start

  # Get the binary depending on OS
  opera_bin =''
  if ENV['OS'] == 'linux'
    opera_bin = '/usr/bin/opera'
  elsif ENV['OS'] == 'mac'
    opera_bin = '/Applications/Opera.app/Contents/MacOS/Opera'
  else
    STDERR.puts "OS/browser is not supported... Aborting..."
    exit 0
  end
  cap = Selenium::WebDriver::Remote::Capabilities.chrome('operaOptions' => {
    'binary' => opera_bin,
    'desiredCapabilities' => {"Geolocation" => {"Enable geolocation" => false}}
  })
  $driver = Selenium::WebDriver.for :chrome, desired_capabilities: cap, switches: %w[--incognito]
else
  $driver = Selenium::WebDriver.for :firefox
end

# Unmaximize window (Firefox).
$driver.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 985)

at_exit do
  $driver.quit
  @service.stop if ENV['SELENIUM_BROWSER'] == 'opera'
end
