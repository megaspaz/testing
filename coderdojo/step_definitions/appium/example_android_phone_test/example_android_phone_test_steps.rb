Given(/^Android on appium starts with chrome$/) do
  BasePage.new($driver.driver).wait_for(2) { $driver.driver.page_source =~ /Chrome/ }
end

Then(/^I get welcome to chrome$/) do
  $driver.driver.page_source.should =~ /Welcome to Chrome/
end
