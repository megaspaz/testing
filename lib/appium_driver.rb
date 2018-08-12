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
      caps = Appium.load_appium_txt(
        file: File.expand_path('./../../config/appium/android/phone/appium.txt', __FILE__), verbose: true)
    else  # tablet_app_android
      caps = Appium.load_appium_txt(
        file: File.expand_path('./../../config/appium/android/tablet/appium.txt', __FILE__), verbose: true)
    end
    return Appium::Driver.new(caps, true)
  end

  def self.init_info(driver=nil, print_outout=false)
    appium_driver ||= driver
    hash = {}
    hash[:automation_name] = appium_driver.automation_name
    hash[:version] = appium_driver.appium_client_version
    hash[:device] = appium_driver.appium_device
    hash[:server_version] = appium_driver.appium_server_version
    hash[:status] = appium_driver.appium_server_status
    hash[:device_name] = appium_driver.caps[:deviceName]
    puts Colored.colorize("Automation Name: #{hash[:automation_name]}\nDevice Name: #{hash[:device_name]}\n" +
           "Device: #{hash[:device]}\nAppium Version: #{hash[:version]}\n" +
           "Server Version: #{hash[:server_version]}\nServer Status: #{hash[:status]}").bold.cyan if print_outout
    return hash
  end
end
