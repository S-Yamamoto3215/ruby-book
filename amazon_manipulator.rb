# frozen_string_literal: true

require 'selenium-webdriver'
require_relative './account_info'

# Class for scraping Amazon purchase history.
class AmazonManipulator
  include AccountInfo

  BASE_URL = 'https://www.amazon.co.jp/'

  def initialize(account_file)
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 20)
    @account = read(account_file)
  end

  def login
    @driver.get BASE_URL
    element = wait_and_find_element(:id, 'nav-link-accountList')
    element.click
    element = wait_and_find_element(:id, 'ap_email')
    element.send_keys(@account[:email])
    element = wait_and_find_element(:id, 'continue')
    element.click
    element = wait_and_find_element(:id, 'ap_password')
    element.send_keys(@account[:password])
    element = wait_and_find_element(:id, 'signInSubmit')
    element.click
    element = wait_and_find_element(:id, 'nav-link-accountList')
  end

  def logout
    element = wait_and_find_element(:id, 'nav-link-accountList')
    @driver.action.move_to(element).perform
    element = wait_and_find_element(:id, 'nav-item-signout')
    element.click
    element = wait_and_find_element(:id, 'ap_email')
  end

  def run
    login
    sleep 2
    element = wait_and_find_element(:id, 'nav-orders')
    element.click
    element = wait_and_find_element(:id, 'navFooter')
    puts @driver.title
    years = @driver.find_element(:id, 'time-filter')
    select = Selenium::WebDriver::Support::Select.new(years)
    select.select_by(:value, 'year-2022')
    @wait.until { @driver.find_element(:id, 'navFooter').displayed? }
    selector = '#ordersContainer .order > div:nth-child(2) .a-fixed-left-grid-col.a-col-right > div:nth-child(1)'
    titles = @driver.find_elements(:css, selector)
    puts "アイテム数: #{titles.size}"
    titles.map { |t| puts t.text }
    sleep 2
    logout
    sleep 2
    @driver.quit
  end

  private

  def wait_and_find_element(how, what)
    @wait.until { @driver.find_element(how, what).displayed? }
    @driver.find_element(how, what)
  end
end

if __FILE__ == $PROGRAM_NAME
  abort 'Usage: ruby web_driver.rb <account.json>' if ARGV.empty?
  app = AmazonManipulator.new(ARGV[0])
  app.run
end
