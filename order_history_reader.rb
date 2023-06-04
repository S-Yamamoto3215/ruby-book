# frozen_string_literal: true

# OrderHistoryReader
class OrderHistoryReader
  def initialize(filename, mode = 'r')
    @file = File.open(filename, mode)
    return unless block_given?

    yield self
    @file.close
  end

  def each
    until @file.eof?
      record = {}
      @file.each do |line|
        if /^(ID|注文番号|注文日|合計|お届け先|明細):\s*(.+)/ =~ line
          record[Regexp.last_match(1)] = Regexp.last_match(2)
        end
        break if record.key?('明細')
      end
      p record
      record['お届け先'] = '指定なし' unless record.key?('お届け先')
      yield record
    end
  end

  def close
    @file.close
  end
end

# Test class
class HistoryFileReadTest
  def put_record(rec)
    puts '-------------'
    rec.each do |key, value|
      puts "#{key}| #{value}"
    end
  end

  def run1(filename)
    OrderHistoryReader.new(filename) do |reader|
      reader.each do |rec|
        put_record(rec)
      end
    end
  end

  def run2(filename)
    reader = OrderHistoryReader.new(filename)
    reader.each do |rec|
      put_record(rec)
    end
    reader.close
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Order History File: #{ARGV[0]}"
  app = HistoryFileReadTest.new
  app.run1(ARGV[0])
  puts '============='
  app.run2(ARGV[0])
end
