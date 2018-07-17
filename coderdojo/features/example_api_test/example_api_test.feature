@api
Feature: Example API test feature

  Scenario: GET request
    Given I send a GET request to Google
    Then the response status is going to be 200
