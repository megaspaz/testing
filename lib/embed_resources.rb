module EmbedResources
  def browser_os
    return "#{ENV['SELENIUM_BROWSER'].capitalize}/#{ENV['OS'].capitalize} OS"
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

  def embed_text
    embed('', '', "<br />#{browser_os}<br />")
  end

  def embed_screenshot
    begin
      encoded_img = $driver.screenshot_as(:base64)
      embed("data:image/png;base64,#{encoded_img}",'image/png', "<br />Screenshot (#{browser_os})<br />")
    rescue Exception => e
      puts "Failed to capture screenshot.\nException:\n#{e}"
    end
  end
end
