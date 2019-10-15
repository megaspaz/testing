module SeleniumDriver

  def self.get_driver
    return $driver unless $driver.nil?

    os = ENV['OS']
    driver, service = nil, nil
    case ENV['SELENIUM_BROWSER']
    when /chrome$/
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--ignore-certificate-errors')
      options.add_argument('--disable-popup-blocking')
      options.add_argument('--disable-translate')
      options.add_argument('--headless') if ENV['SELENIUM_BROWSER'].start_with?('headless')
      driver = Selenium::WebDriver.for :chrome, options: options
    when 'opera'
      if os == 'windows-wsl'
        puts Colored.colorize('Opera not supported on Windows Subsystem for Linux. Aborting...').bold.yellow
        exit 0
      end
      service = Selenium::WebDriver::Chrome::Service.new('/usr/bin/operadriver', 12345, {})
      service.start

      # Get the binary depending on OS
      opera_bin =''
      case os
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
      driver = Selenium::WebDriver.for(:remote, :url => service.uri, :desired_capabilities => cap)
    when 'safari'
      unless os == 'mac'
        puts Colored.colorize('Safari supported only on Mac OS. Aborting...').bold.yellow
        exit 0
      end
      driver = Selenium::WebDriver.for :safari
    when 'edge'
      unless os == 'windows-wsl'
        puts Colored.colorize('Microsoft Edge supported only on Windows Subsystem for Linux. Aborting...').bold.yellow
        exit 0
      end
      service = Selenium::WebDriver::Edge::Service.new('/usr/bin/MicrosoftWebDriver', 12345,
                                                       {:args => '--host=127.0.0.1'})
      service.start
      caps = Selenium::WebDriver::Remote::Capabilities.edge
      driver = Selenium::WebDriver.for :remote, :url => service.uri, desired_capabilities: caps
    when 'ie'
      if os != 'cygwin'
        puts Colored.colorize('IE supported only on Windows under Cygwin. Aborting...').bold.yellow
        exit 0
      end

      caps = Selenium::WebDriver::Remote::Capabilities.new
      caps['browser'] = 'IE'
      caps['os'] = 'Windows'
      caps['os_version'] = '10'

      driver = Selenium::WebDriver.for(:remote,
                                       :url => "http://localhost:5555",
                                       :desired_capabilities => caps)
    else
      if os == 'windows-wsl'
        puts Colored.colorize('Firefox not supported on Windows Subsystem for Linux. Aborting...').bold.yellow
        exit 0
      end
      # Firefox default
      driver = Selenium::WebDriver.for :firefox
    end

    case ENV['VIEW_IMPL']
    when 'mobile_web'
      resolution = [480, 800]
    when 'tablet_web'
      resolution = [1024, 768]
    else
      # desktop by default
      resolution = [1024, 985]
    end
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(*resolution)
    return driver, service
  end
end
