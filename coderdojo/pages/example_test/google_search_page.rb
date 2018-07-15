class GoogleSearchPage < BasePage

  SEARCH_BOX        = { css: 'div#sb_ifc0 div#gs_lc0 input#lst-ib'  }
  SEARCH_BOX_SUBMIT = { css: 'div.jsb input[value="Google Search"]' }

  @page_url = 'https://www.google.com'
  def initialize(driver)
    super(driver)
    wait_for(5) { find(SEARCH_BOX).displayed? && find(SEARCH_BOX_SUBMIT).displayed? }
  end

  def search_for(search_for)
    type(SEARCH_BOX, search_for)
    type_meta(:escape)
    click_on(SEARCH_BOX_SUBMIT)
  end
end
