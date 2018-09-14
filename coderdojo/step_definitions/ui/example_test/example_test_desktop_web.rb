module ExampleTestHelpers
  module ExampleTestDesktopWeb

    def search(search_for)
      GoogleSearchPage.new($driver).search_for(search_for)
    end

    def verify_search_results
      results_page = GoogleSearchResultsPage.new($driver)
      if ENV['OS'] == 'mac'
        results_page.move_to_results unless ENV['SELENIUM_BROWSER'] == 'safari'
        sleep 1
      end
      @results_list = results_page.search_results
      expect(@results_list.length).to be > 0
    end

    def click_first_result
      google_title = 'Google Search'
      results_page = GoogleSearchResultsPage.new($driver)
      results_page.click_first_result
      if ENV['SELENIUM_BROWSER'] == 'safari'
        # Safari doesn't block on page loading after clicking link. Would fail right away with title having Google Search.
        # The wait acts the same as an assertion if it fails... call it again though...
        results_page.wait_for(2) { results_page.title.include?(google_title) == false }
      end
      page_title = results_page.title
      puts Colored.colorize("PAGE TITLE: #{page_title}").bold.cyan
      expect(page_title).to_not include google_title unless ENV['SELENIUM_BROWSER'] == 'opera'
    end
  end
end
