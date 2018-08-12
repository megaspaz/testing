Given(/^I show some appium information$/) do
  @appium_init_info = AppiumDriver.init_info($driver, true)
end

Then(/^the automation name and device will match appium.txt$/) do
  expect(@appium_init_info[:automation_name].to_s).to eql 'XCUITest'.downcase
  expect(@appium_init_info[:device_name].to_s).to eql ENV['VIEW_IMPL'] == 'mobile_app_ios' ? 'iPhone 6' : 'iPad Air'
  expect(@appium_init_info[:device].to_s).to eql 'ios'
end
