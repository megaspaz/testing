module AppiumDriver

  def self.get_driver
    return $driver unless $driver.nil?

    os = OsSniffer.get_local_os
    case ENV['VIEW_IMPL']
    when /^(mobile|tablet)_app_ios$/
      unless os == 'mac'
        puts Colored.colorize('IOS requires Mac. Aborting...').bold.yellow
        exit 0
      end
      if ENV['VIEW_IMPL'] =~ /^mobile/
        caps = Appium.load_appium_txt(
          file: File.expand_path('./../../config/appium/ios/iphone/appium.txt', __FILE__), verbose: true)
      else
        caps = Appium.load_appium_txt(
          file: File.expand_path('./../../config/appium/ios/ipad/appium.txt', __FILE__), verbose: true)
      end
    when 'mobile_app_android'
      puts Colored.colorize('Not implemented...').bold.yellow
      exit 0
      caps = Appium.load_appium_txt(
        file: File.expand_path('./../../config/appium/android/appium.txt', __FILE__), verbose: true)
    else  # tablet_app_android
      puts Colored.colorize('Not implemented...').bold.yellow
      exit 0
      caps = Appium.load_appium_txt(
        file: File.expand_path('./../../config/appium/android/appium.txt', __FILE__), verbose: true)
    end
    $driver = Appium::Driver.new(caps, true)
  end
end
