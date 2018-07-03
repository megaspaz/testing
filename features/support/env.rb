require 'colored'
require 'rbconfig'
require 'selenium-webdriver'

module OsSniffer
  include RbConfig
  def self.get_local_os
    STDOUT.puts "Determining host operating system... #{RbConfig::CONFIG['host_os']}"

    case RbConfig::CONFIG['host_os']
    when /mswin|windows/i
      return "windows"
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
    puts Colored.colorize("OS/browser is not supported... Aborting...").bold.yellow
    exit 0
  end
  cap = Selenium::WebDriver::Remote::Capabilities.chrome('operaOptions' => {
    'binary' => opera_bin,
    'args' => %w('--ignore-certificate-errors' '--disable-popup-blocking' '--disable-translate')
  })
  $driver = Selenium::WebDriver.for(:remote, :url => @service.uri, :desired_capabilities => cap)
when 'safari'
  unless ENV['OS'] == 'mac'
    puts Colored.colorize('Safari supported only on Mac OS. Aborting...').bold.yellow
    exit 0
  end
  $driver = Selenium::WebDriver.for :safari
else
  # Firefox default
  $driver = Selenium::WebDriver.for :firefox
end

# Unmaximize window (Firefox).
$driver.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 985)

# Take a screenshot on fail.
After do |scenario|
  if scenario.failed?
    time_now = Time.now.to_i
    begin
      filename = "html_dump-#{time_now}.txt"
      full_path = File.join(Dir.pwd, 'results', filename)
      File.open(full_path, 'w') { |file| file.write($driver.page_source) }
      embed(filename, "text/html", '<br />HTML Dump&nbsp;')
    rescue Exception => e
      $stdout.puts "Failed to embed HTML dump."
      $stdout.puts e.message
      e.backtrace.each { |l| $stdout.puts l }
    end

    begin
      browser_os = "#{ENV['SELENIUM_BROWSER'].capitalize}/#{ENV['OS'].capitalize} OS"
      encoded_img = $driver.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}",'image/png', "&nbsp;Screenshot (#{browser_os})<br /><br />")
    rescue Exception => e
      puts "Failed to capture screenshot.\nException:\n#{e}"
    end
  end
end

at_exit do
  $driver.quit
  puts Colored.colorize(
    'Safari requires manually quitting the browser...').bold.yellow if ENV['SELENIUM_BROWSER'] == 'safari'
  @service.stop if ENV['SELENIUM_BROWSER'] == 'opera'
end
