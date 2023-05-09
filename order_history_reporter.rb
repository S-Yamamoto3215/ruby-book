# frozen_string_literal: true

require_relative './account_info'
require_relative './amazon_manipulator'

# Application class (OHR)
class OrderHistoryReporter
  include AccountInfo

  def initialize(account_file)
    @account = read(account_file)
    @amazon = AmazonManipulator.new
  end

  def collect_order_history
    title = @amazon.open_order_list
    puts title
    @amazon.change_order_term
    @amazon.collect_ordered_items
  end

  def make_report(order_infos)
    puts "#{order_infos.size} 件"
    order_infos.each do |id, rec|
      puts "ID: #{id}"
      rec.each do |key, val|
        puts format '%s: %s', key, val
      end
    end
  end

  def run
    @amazon.login(@account)
    order_infos = collect_order_history
    @amazon.logout
    make_report(order_infos)
  end
end

if __FILE__ == $PROGRAM_NAME
  abort 'Usage: ruby web_driver.rb <account.json>' if ARGV.empty?
  app = OrderHistoryReporter.new(ARGV[0])
  app.run
end
