Given(/^Android on appium starts with chrome$/) do
  @automation_name = $driver.automation_name
  @version = $driver.appium_client_version
  @device = $driver.appium_device
  @server_version = $driver.appium_server_version
  @status = $driver.appium_server_status
  puts "Automation Name: #{@automation_name}\nDevice: #{@device}\nAppium Version: #{@version}\n" +
         "Server Version: #{@server_version}\nServer Status: #{@status}"
  BasePage.new($driver.driver).wait_for(2) { $driver.get_source =~ /Chrome/ }
end

Then(/^I get welcome to chrome$/) do
  $driver.get_source.should =~ /Welcome to Chrome/
  expect(@automation_name.to_s).to eql 'uiautomator2'
  expect(@device.to_s).to eql 'android'
end
