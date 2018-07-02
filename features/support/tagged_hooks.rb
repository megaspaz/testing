Before('@no_mac') do
  if ENV['OS'] == 'mac'
    pending 'Do not run on Mac'
  end
end

Before('@no_linux') do
  if ENV['OS'] == 'linux'
    pending 'Do not run on Linux'
  end
end

Before('@no_firefox_on_mac') do
  if ENV['OS'] == 'mac' && ENV['SELENIUM_BROWSER'] == 'firefox'
    pending 'Do not run for Firefox on Mac'
  end
end

Before('@no_firefox_on_linux') do
  if ENV['OS'] == 'linux' && ENV['SELENIUM_BROWSER'] == 'firefox'
    pending 'Do not run for Firefox on Linux'
  end
end

Before('@no_chrome_on_mac') do
  if ENV['OS'] == 'mac' && ENV['SELENIUM_BROWSER'] == 'chrome'
    pending 'Do not run for Chrome on Mac'
  end
end

Before('@no_chrome_on_linux') do
  if ENV['OS'] == 'linux' && ENV['SELENIUM_BROWSER'] == 'chrome'
    pending 'Do not run for Chrome on Linux'
  end
end

Before('@no_opera_on_mac') do
  if ENV['OS'] == 'mac' && ENV['SELENIUM_BROWSER'] == 'opera'
    pending 'Do not run for Opera on Mac'
  end
end

Before('@no_opera_on_linux') do
  if ENV['OS'] == 'linux' && ENV['SELENIUM_BROWSER'] == 'opera'
    pending 'Do not run for Opera on Linux'
  end
end

Before('@no_safari') do
  if ENV['SELENIUM_BROWSER'] == 'safari'
    pending 'Do not run for Safari'
  end
end
