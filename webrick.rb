# frozen_string_literal: true

require 'webrick'
require 'date'
require 'erb'

config = {
  DocumentRoot: './',
  BindAddress: '127.0.0.1',
  Port: 8099
}

server = WEBrick::HTTPServer.new(config)

server.mount_proc('/testprog') do |req, res|
  today = Date.today.to_s
  template = ERB.new(File.read('webrick.erb'))
  res.body = template.result(binding)
end

trap(:INT) { server.shutdown }

server.start

if __FILE__ == $PROGRAM_NAME
  app = OrderHistoryWebApp.new(ARGV)
  app.run
end
