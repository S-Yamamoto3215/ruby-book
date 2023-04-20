# fronzen_string_literal: true

require 'selenium-webdriver'
require_relative './account_reader'

abort 'Usage: ruby web_driver.rb <account.json>' if ARGV.empty?
account = read_account(ARGV[0])


driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(timeout: 20)

driver.get 'https://www.amazon.co.jp/'
element = driver.find_element(:id, 'nav-link-accountList')
element.click

wait.until { driver.find_element(:id, 'ap_email').displayed? }
element = driver.find_element(:id, 'ap_email')
element.send_keys(account[:email])

element = driver.find_element(:id, 'continue')
element.click

wait.until { driver.find_element(:id, 'ap_password').displayed? }
element = driver.find_element(:id, 'ap_password')
element.send_keys(account[:password])

element = driver.find_element(:id, 'signInSubmit')
element.click
sleep 10
wait.until { driver.find_element(:id, 'nav-link-accountList').displayed? }
sleep 3
driver.quit
