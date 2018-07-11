Given(/^I go to Google$/) do
  $driver.navigate.to "https://www.google.com"
end

When(/^I search for (kittens|puppies)$/) do |search_for|
  Selenium::WebDriver::Wait.new(:timeout => 5).until {
    $driver.find_element(:css, 'div#sb_ifc0 div#gs_lc0 input#lst-ib')
  }
  $driver.find_element(:css, 'div#sb_ifc0 div#gs_lc0 input#lst-ib').send_keys(search_for)
  $driver.action.send_keys(:escape).perform
  $driver.find_element(:css, 'div.jsb input[value="Google Search"]').click()
end

Then(/^I will see search results$/) do
  @result_locator = 'div.bkWMgd div.srg div.g div.rc h3.r a'
  if ENV['OS'] == 'mac'
    $driver.action.move_to(
      $driver.find_element(:css, @result_locator)).perform unless ENV['SELENIUM_BROWSER'] == 'safari'
    sleep 1
  end
  Selenium::WebDriver::Wait.new(:timeout => 5).until { @results_list = $driver.find_elements(:css, @result_locator) }
  expect(@results_list.length).to be > 0
end

Given(/^I click on the first search result$/) do
  @results_list[0].click()
  page_title = $driver.title
  puts "PAGE TITLE; #{page_title}"
  expect(page_title).to_not include 'Google Search' unless ENV['SELENIUM_BROWSER'] == 'opera'
end
