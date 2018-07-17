steps_helper = StepModuleHelper.create_helper_module("ExampleTest")

Given(/^I go to Google$/) do
  steps_helper.go_to_google
end

When(/^I search for (kittens|puppies)$/) do |search_for|
  steps_helper.search(search_for)
end

Then(/^I will see search results$/) do
  steps_helper.verify_search_results
end

Given(/^I click on the first search result$/) do
  steps_helper.click_first_result
end
