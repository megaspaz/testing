Given(/^Android on appium starts with chrome$/) do
  @appium_init_info = AppiumDriver.init_info($driver, true)
  BasePage.new($driver.driver).wait_for(2) { $driver.get_source =~ /Chrome/ }
end

Then(/^I get welcome to chrome$/) do
  $driver.get_source.should =~ /Welcome to Chrome/
  expect(@appium_init_info[:automation_name].to_s).to eql 'uiautomator2'
  expect(@appium_init_info[:device_name].to_s).to eql ENV['VIEW_IMPL'] == 'mobile_app_android' ?
                                                        'Nexus_5X_API_28' : 'Nexus_10_API_28'
  expect(@appium_init_info[:device].to_s).to eql 'android'
end
