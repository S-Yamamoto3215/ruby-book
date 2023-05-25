# frozen_string_literal: true

class LongTimeTest
  def run
    puts 'start'
    sleep(10)
    puts 'end'
  end
end

if __FILE__ == $PROGRAM_NAME
  LongTimeTest.new.run
  if ARGV.include? 'account.json'
    puts 'OK.'
    exit true
  else
    puts 'ERROR.'
    exit false
  end
end
