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
    open_top_page
    open_login_page
    enter_email
    enter_password
    wait_for_loged_in
  end

  def logout
    open_nav_link_popup
    wait_for_loged_out
  end

  def open_order_list
    element = wait_and_find_element(:id, 'nav-orders')
    element.click
    wait_and_find_element(:id, 'navFooter')
    puts @driver.title
  end

  def change_order_term
    years = @driver.find_element(:id, 'time-filter')
    select = Selenium::WebDriver::Support::Select.new(years)
    select.select_by(:value, 'year-2022')
    @wait.until { @driver.find_element(:id, 'navFooter').displayed? }
  end

  def list_ordered_items
    selector = '#ordersContainer .order > div:nth-child(2) .a-fixed-left-grid-col.a-col-right > div:nth-child(1)'
    titles = @driver.find_elements(:css, selector)
    puts "アイテム数: #{titles.size}"
    titles.map { |t| puts t.text }
    sleep 2
  end

  def run
    login
    sleep 2
    open_order_list
    change_order_term
    list_ordered_items
    logout
    sleep 2
    @driver.quit
  end

  private

  def wait_and_find_element(how, what)
    @wait.until { @driver.find_element(how, what).displayed? }
    @driver.find_element(how, what)
  end

  def open_top_page
    @driver.get BASE_URL
    wait_and_find_element(:id, 'navFooter')
  end

  def open_login_page
    element = wait_and_find_element(:id, 'nav-link-accountList')
    element.click
  end

  def enter_email
    element = wait_and_find_element(:id, 'ap_email')
    element.send_keys(@account[:email])
    @driver.find_element(:id, 'continue').click
  end

  def enter_password
    element = wait_and_find_element(:id, 'ap_password')
    element.send_keys(@account[:password])
    @driver.find_element(:id, 'signInSubmit').click
  end

  def wait_for_loged_in
    wait_and_find_element(:id, 'nav-link-accountList')
  end

  def open_nav_link_popup
    element = wait_and_find_element(:id, 'nav-link-accountList')
    @driver.action.move_to(element).perform
  end

  def wait_for_loged_out
    element = wait_and_find_element(:id, 'nav-item-signout')
    element.click
    wait_and_find_element(:id, 'ap_email')
  end
end

if __FILE__ == $PROGRAM_NAME
  abort 'Usage: ruby web_driver.rb <account.json>' if ARGV.empty?
  app = AmazonManipulator.new(ARGV[0])
  app.run
end
