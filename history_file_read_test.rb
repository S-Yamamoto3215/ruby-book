# frozen_string_literal: true

# Test class
class HistoryFileReadTest
  def run(filename)
    File.open(filename) do |file|
      file.each_line do |line|
        print line
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Order History File: #{ARGV[0]}"
  app = HistoryFileReadTest.new
  app.run(ARGV[0])
end
