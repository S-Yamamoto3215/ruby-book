# frozen_string_literal: true

require 'optparse'

opts = OptionParser.new
opts.banner = 'Usage: optparse_sample.rb [options]'
opts.program_name = 'optparse_sample'
opts.version = [0, 2]
opts.release = '2023-05-04'

opts.on_tail('-v', '--version', 'バージョンを表示する') do
  puts opts.ver
  exit
end

opts.parse!(ARGV)
