class GoogleSearchResultsPage < BasePage

  SEARCH_RESULT = { css: 'div.bkWMgd div.srg div.g div.rc h3.r a' }

  def initialize(driver)
    super(driver)
    wait_for(5) { find(SEARCH_RESULT).displayed? }
  end

  def move_to_results
    move_to(SEARCH_RESULT)
  end

  def search_results
    return find_elements(SEARCH_RESULT)
  end

  def click_first_result
    click_on(SEARCH_RESULT)
  end
end
