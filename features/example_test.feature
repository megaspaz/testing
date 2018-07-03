Feature: Example test feature

  Background:
    Given I go to Google

  Scenario Outline: Searching for kittens & puppies
    When I search for <search_for>
    Then I will see search results
    And I click on the first search result

    Examples: : Searching for kittens
      | search_for |
      | kittens    |

    @no_firefox_on_mac
    Examples: : Searching for puppies
      | puppies    |
