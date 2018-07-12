![Cucumber...](https://media.giphy.com/media/izmmV5H6RSSRO/giphy.gif)
<br/>
# Follow if doing from scratch...

- #### Install RVM and Ruby
    - #### Linux
        - follow https://github.com/rvm/ubuntu_rvm
            ```
            sudo apt-get install software-properties-common
            sudo apt-add-repository -y ppa:rael-gc/rvm
            sudo apt-get update
            sudo apt-get install rvm
            ```
            Reboot<br />
            ```
            rvm install ruby
            ```
    - #### Mac
        - from https://rvm.io/rvm/install
            ```
            \curl -sSL https://get.rvm.io | bash -s stable --ruby
            ```

- #### Make a project directory and 'cd' to the new project directory
    ```
    mkdir testing
    cd testing
    ```

- #### Install *bundler*
    ```
    gem install bundler
    gem install rubygems-update
    ```

- #### Create a file called *Gemfile* (Contents of file is below... Bear in mind, the versions may need changing!)
    ```
    source 'https://rubygems.org'

    ruby '2.5.1'

    gem 'cucumber', '3.1.1'
    gem 'rspec', '3.7.0'
    gem 'rspec-expectations', '3.7.0'
    gem 'rake'
    gem 'selenium-webdriver'
    ```
    
- #### Run *bundle install*
    ```
    bundle install
    ```

- #### Run initial cucumber
    ```
    cucumber --init
    ```

- #### Get Selenium browser drivers *(Mac & Linux)*
    - ##### Firefox
        - Get ***geckodriver*** from https://github.com/mozilla/geckodriver/releases
  for example, you might get ***geckodriver-v0.21.0-linux64.tar.gz*** or ***geckodriver-v0.21.0-macos.tar.gz***

        - Uncompress ***geckodriver-v0.21.0-linux64.tar.gz***  or ***geckodriver-v0.21.0-macos.tar.gz***
        
        - Install
            ```
            sudo cp geckodriver /usr/bin/.
            sudo chmod 755 /usr/bin/geckodriver
            ```

    - ##### Chrome
        - Get ***chromedriver*** from https://sites.google.com/a/chromium.org/chromedriver/downloads
  for example, you might get the latest, which is now ***ChromeDriver 2.40***, at
  https://chromedriver.storage.googleapis.com/index.html?path=2.40/

        - Uncompress ***chromedriver_linux64.zip*** or ***chromedriver_mac64.zip***

        - Install
            ```
            sudo cp chromedriver /usr/bin/.
            sudo chmod 755 /usr/bin/chromedriver
            ```
    - ##### Opera
        - Get ***operadriver*** from https://github.com/operasoftware/operachromiumdriver/releases
  for example, you might get the latest, which is ***version 2.36***.

        - Uncompress ***operadriver_linux64.zip*** or ***operadriver_mac64.zip***

        - Install
            ```
            sudo cp operadriver /usr/bin/.
            sudo chmod 755 /usr/bin/operadriver
           ```
    - ##### Safari (Mac Only)
        - As of 2016, ***safaridriver*** is bundled automatically by Apple.
        - Prior to running automation, open ***Safari*** and in the ***Developer*** menu item, select the ***Allow Remote Automation*** option.  

- #### Write some cucumber! Enjoy!
    Try the example in your top-level project directory, from the terminal, either:
    ```
    cucumber -p chrome
    ```
    or
    ```
    cucumber -p firefox
    cucumber -p firefox -p debug
    ```
    or
    ```
    cucumber -p opera
    ```
    or
    ```
    cucumber -p safari
    ```
