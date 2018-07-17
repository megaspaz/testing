module ExampleTestHelpers
  module ExampleTestTemplate

    def go_to_google
      GoogleSearchPage.visit(GoogleSearchPage.page_url, $driver)
    end

    def search(search_for)
      raise Cucumber::Pending, 'Implement me!'
    end

    def verify_search_results
      raise Cucumber::Pending, 'Implement me!'
    end

    def click_first_result
      raise Cucumber::Pending, 'Implement me!'
    end
  end
end
