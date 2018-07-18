Given(/^I show some appium information$/) do
  @automation_name = $driver.automation_name
  @version = $driver.appium_client_version
  @device = $driver.appium_device
  @server_version = $driver.appium_server_version
  @status = $driver.appium_server_status
  puts "Automation Name: #{@automation_name}\nDevice: #{@device}\nAppium Version: #{@version}\n" +
    "Server Version: #{@server_version}\nServer Status: #{@status}"
end

Then(/^the automation name and device will match appium.txt$/) do
  expect(@automation_name.to_s).to eql 'XCUITest'.downcase
  expect(@device.to_s).to eql 'ios'
end
