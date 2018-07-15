class BasePage

  class << self
    attr_reader :driver, :page_url
  end

  @page_url = '/'
  def initialize(driver)
    @driver = driver
  end

  def visit(page_url)
    self.class.visit(page_url, @driver)
  end

  def self.visit(page_url, driver)
    #allow timeouts when unnecessary components loading on page
    begin
      driver.get(page_url)
    rescue Net::ReadTimeout => e
      if allow_timeout
        driver.execute_script("window.stop();")
      else
        raise e
      end
    end
  end

  def find(locator)
    @driver.find_element locator
  end

  def find_elements(locator)
    @driver.find_elements locator
  end

  def clear(locator)
    find(locator).clear
  end

  def type_meta(meta_input)
    @driver.action.send_keys(meta_input).perform
  end

  def type(locator, input)
    find(locator).send_keys input
  end

  def move_to(locator)
    $driver.action.move_to(find(locator)).perform
  end

  def click_on(locator)
    find(locator).click
  end

  def displayed?(locator)
    begin
      return find(locator).displayed?
    rescue Selenium::WebDriver::Error::NoSuchElementError, Selenium::WebDriver::Error::StaleElementReferenceError => e
      return false
    end
  end

  def text_of(locator)
    find(locator).text
  end

  def title
    @driver.title
  end

  def wait_for(seconds=5)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until { yield }
  end

  def script_execute(script, element_target=nil)
    return (element_target != nil) ? @driver.execute_script(script, element_target) : @driver.execute_script(script)
  end
end
