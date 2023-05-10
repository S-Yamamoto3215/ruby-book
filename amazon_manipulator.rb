# frozen_string_literal: true

require 'selenium-webdriver'

# Service class
class AmazonManipulator
  include Selenium::WebDriver::Error

  BASE_URL = 'https://www.amazon.co.jp/'

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 20)
  end

  def login(account)
    open_top_page
    open_login_page
    enter_email(account[:email])
    enter_password(account[:password])
    wait_for_loged_in
  end

  def logout
    open_nav_link_popup
    wait_for_loged_out
  end

  def open_order_list
    element = wait_and_find_element(:id, 'nav-orders')
    element.click
    @wait.until { @driver.find_element(:id, 'navFooter').displayed? }
    @driver.title
  end

  def change_order_term(order_term)
    years = @driver.find_element(:id, 'time-filter')
    select = Selenium::WebDriver::Support::Select.new(years)
    select.select_by(:value, order_term)
    @wait.until { @driver.find_element(:id, 'navFooter').displayed? }
  end

  def collect_ordered_items
    order_infos = {}

    loop do
      collect_ordered_items_by_page(order_infos)
      begin
        pagination = @driver.find_element(:class, 'a-pagination')
        next_button = pagination.find_element(:class, 'a-last')
        next_link = next_button.find_element(:css, 'a')
      rescue NoSuchElementError
        break
      end
      next_link.click
      wait_and_find_element(:id, 'ordersContainer')
    end
    order_infos
  end

  def collect_ordered_items_by_page(order_infos)
    orders_container = @driver.find_element(:id, 'ordersContainer')

    orders = orders_container.find_elements(:class, 'order')
    orders.each do |order|
      key = order.find_element(:tag_name, 'bdi').text
      order_infos[key] = {}

      info = order.find_element(:class, 'order-info')

      right = info.find_element(:class, 'a-col-right')
      label = right.find_element(:class, 'label').text
      value = right.find_element(:class, 'value').text
      order_infos[key][label] = value

      left = info.find_element(:class, 'a-col-left')
      cols = left.find_elements(:class, 'a-column')
      cols.each do |col|
        begin
          label = col.find_element(:class, 'label')
        rescue NoSuchElementError
          # p 'no such element error'
          next
        end

        label = label.text
        value = col.find_element(:class, 'value').text
        order_infos[key][label] = value
      end

      order_infos[key]['明細'] = []

      selector = 'div:nth-child(2) .a-fixed-left-grid-col.a-col-right'
      details = order.find_elements(:css, selector)

      details.each do |detail_rows|
        rows = detail_rows.find_elements(:class, 'a-row')
        row_array = []
        rows.each do |row|
          row_array << row.text
        end
        order_infos[key]['明細'] << row_array.uniq
      end
    end
    order_infos
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

  def enter_email(email)
    element = wait_and_find_element(:id, 'ap_email')
    element.send_keys(email)
    @driver.find_element(:id, 'continue').click
  end

  def enter_password(password)
    element = wait_and_find_element(:id, 'ap_password')
    element.send_keys(password)
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
