module EmbedResources
  def browser_os
    return "#{ENV['SELENIUM_BROWSER'].capitalize}/#{ENV['OS'].capitalize} OS"
  end

  def view_impl
    return "#{ENV['VIEW_IMPL'].upcase}"
  end

  def embed_html
    time_now = Time.now.to_i
    begin
      filename = "html_dump-#{time_now}.txt"
      full_path = File.join(Dir.pwd, 'results', filename)
      File.open(full_path, 'w') { |file| file.write($driver.page_source) }
      embed(filename, "text/html", '<br />HTML Dump<br />')
    rescue Exception => e
      puts "Failed to embed HTML dump."
      puts e.message
      e.backtrace.each { |l| puts l }
    end
  end

  def embed_browser_os
    embed_text("<br />#{browser_os}<br />")
  end

  def embed_view_impl
    embed_text("<br />#{view_impl}<br />")
  end

  def embed_text(text)
    embed('', '', text)
  end

  def embed_screenshot
    begin
      case ENV['VIEW_IMPL']
      when /^(desktop|mobile|tablet)_web$/
        encoded_img = $driver.screenshot_as(:base64)
        link_text = "<br />Screenshot (#{browser_os})<br />"
      when /^(mobile|tablet)_app_(android|ios)$/
        encoded_img = $driver.driver.screenshot_as(:base64)
        link_text = "<br />Screenshot (#{view_impl})<br />"
      else
        raise 'Unknown view implementation.'
      end
      embed("data:image/png;base64,#{encoded_img}",'image/png', link_text)
    rescue Exception => e
      puts "Failed to capture screenshot.\nException:\n#{e}"
    end
  end
end
