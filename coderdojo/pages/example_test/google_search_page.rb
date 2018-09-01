class GoogleSearchPage < BasePage

  SEARCH_BOX        = { css: 'input[name="q"]'  }
  SEARCH_BOX_SUBMIT = { css: 'input[type="submit"]' }

  @page_url = 'https://www.google.com'
  def initialize(driver)
    super(driver)
    wait_for(5) { find(SEARCH_BOX).displayed? }
  end

  def search_for(search_for)
    type(SEARCH_BOX, search_for)
    type_meta(:escape)
    wait_for(5) { find(SEARCH_BOX_SUBMIT).displayed? }
    click_on(SEARCH_BOX_SUBMIT)
  end
end
