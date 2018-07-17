Given(/^I send a GET request to Google$/) do
  @response = $api_client.get('https://www.google.com')
end

Then(/^the response status is going to be 200$/) do
  expect(@response.code).to be 200
end
