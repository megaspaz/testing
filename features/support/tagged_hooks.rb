Before('@no_mac') do
  pending 'Do not run on Mac' if ENV['OS'] == 'mac'
end

Before('@no_linux') do
  pending 'Do not run on Linux' if ENV['OS'] == 'linux'
end

Before('@no_firefox_on_mac') do
  pending 'Do not run for Firefox on Mac' if ENV['OS'] == 'mac' && ENV['SELENIUM_BROWSER'] == 'firefox'
end

Before('@no_firefox_on_linux') do
  pending 'Do not run for Firefox on Linux' if ENV['OS'] == 'linux' && ENV['SELENIUM_BROWSER'] == 'firefox'
end

Before('@no_chrome_on_mac') do
  pending 'Do not run for Chrome on Mac' if ENV['OS'] == 'mac' && ENV['SELENIUM_BROWSER'] == 'chrome'
end

Before('@no_chrome_on_linux') do
  pending 'Do not run for Chrome on Linux' if ENV['OS'] == 'linux' && ENV['SELENIUM_BROWSER'] == 'chrome'
end

Before('@no_opera_on_mac') do
  pending 'Do not run for Opera on Mac' if ENV['OS'] == 'mac' && ENV['SELENIUM_BROWSER'] == 'opera'
end

Before('@no_opera_on_linux') do
  pending 'Do not run for Opera on Linux' if ENV['OS'] == 'linux' && ENV['SELENIUM_BROWSER'] == 'opera'
end

Before('@no_safari') do
  pending 'Do not run for Safari' if ENV['SELENIUM_BROWSER'] == 'safari'
end
