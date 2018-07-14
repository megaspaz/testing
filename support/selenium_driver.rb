class SeleniumDriver

  def initialize(browser, os)
    @browser = browser
    @os = os
  end

  def get_driver

    driver, service = nil, nil
    case @browser
    when /chrome$/
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--ignore-certificate-errors')
      options.add_argument('--disable-popup-blocking')
      options.add_argument('--disable-translate')
      options.add_argument('--headless') if @browser.start_with?('headless')
      driver = Selenium::WebDriver.for :chrome, options: options
    when 'opera'
      service = Selenium::WebDriver::Chrome::Service.new('/usr/bin/operadriver', 12345, {})
      service.start

      # Get the binary depending on OS
      opera_bin =''
      case @os
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
      unless @os == 'mac'
        puts Colored.colorize('Safari supported only on Mac OS. Aborting...').bold.yellow
        exit 0
      end
      driver = Selenium::WebDriver.for :safari
    else
      # Firefox default
      driver = Selenium::WebDriver.for :firefox
    end
    # Unmaximize window (Firefox).
    driver.manage.window.size = Selenium::WebDriver::Dimension.new(1024, 985)
    return driver, service
  end
end
