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

case ENV['SELENIUM_BROWSER']
when 'chrome'
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-translate')
  $driver = Selenium::WebDriver.for :chrome, options: options
when 'opera'
  @service = Selenium::WebDriver::Chrome::Service.new('/usr/bin/operadriver', 12345, {})
  @service.start

  # Get the binary depending on OS
  opera_bin =''
  case ENV['OS']
  when 'linux'
    opera_bin = '/usr/bin/opera'
  when 'mac'
    opera_bin = '/Applications/Opera.app/Contents/MacOS/Opera'
  else
    STDERR.puts "OS/browser is not supported... Aborting..."
    exit 0
  end
  cap = Selenium::WebDriver::Remote::Capabilities.chrome('operaOptions' => {
    'binary' => opera_bin,
    'args' => %w('--ignore-certificate-errors' '--disable-popup-blocking' '--disable-translate')
  })
  $driver = Selenium::WebDriver.for(:remote, :url => @service.uri, :desired_capabilities => cap)
else
  # Firefox default
  $driver = Selenium::WebDriver.for :firefox
end

# Unmaximize window (Firefox).
$driver.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 985)

at_exit do
  $driver.quit
  @service.stop if ENV['SELENIUM_BROWSER'] == 'opera'
end
