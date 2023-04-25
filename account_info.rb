# frozen_string_literal: true

require 'json'

module AccountInfo
  def read(filename)
    File.open(filename) do |file|
      JSON.parse(File.read(file), symbolize_names: true)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  class AccountInfoTest
    include AccountInfo
  end

  info_test = AccountInfoTest.new
  account = info_test.read(ARGV[0])
  p account
  puts account[:email]
  puts account[:password]
end
