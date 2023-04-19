# fronzen_string_literal: true

require 'selenium-webdriver'
require_relative './account_reader'

abort 'Usage: ruby web_driver.rb <account.json>' if ARGV.empty?
account = read_account(ARGV[0])


driver = Selenium::WebDriver.for :chrome
driver.get 'https://www.amazon.co.jp/'
element = driver.find_element(:id, 'nav-link-accountList')
element.click

element = driver.find_element(:id, 'ap_email')
element.send_keys(account[:email])

element = driver.find_element(:id, 'continue')
element.click

sleep 3
driver.quit
