Given(/^I show some appium information$/) do
  @automation_name = $driver.automation_name
  @version = $driver.appium_client_version
  @device = $driver.appium_device
  puts "Automation Name: #{@automation_name}\nDevice: #{@device}\nAppium Version: #{@version}"
end

Then(/^the automation name and device will match appium.txt$/) do
  expect(@automation_name.to_s).to eql 'XCUITest'.downcase
  expect(@device.to_s).to eql 'ios'
end
