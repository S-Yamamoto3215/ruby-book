# frozen_string_literal: true

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

wait.until { driver.find_element(:id, 'nav-orders').displayed? }
element = driver.find_element(:id, 'nav-orders')
element.click
wait.until { driver.find_element(:id, 'navFooter').displayed? }
puts driver.title

years = driver.find_element(:id, 'time-filter')
select = Selenium::WebDriver::Support::Select.new(years)
select.select_by(:value, 'year-2022')
wait.until { driver.find_element(:id, 'navFooter').displayed? }

selector = '#ordersContainer .order > div:nth-child(2) .a-fixed-left-grid-col.a-col-right > div:nth-child(1)'
titles = driver.find_elements(:css, selector)
puts "アイテム数: #{titles.size}"
titles.map { |t| puts t.text }

sleep 3
driver.quit
