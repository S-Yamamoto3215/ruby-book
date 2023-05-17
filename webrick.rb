# frozen_string_literal: true

require 'webrick'

config = {
  DocumentRoot: './',
  BindAddress: '127.0.0.1',
  Port: 8099,
}

server = WEBrick::HTTPServer.new(config)

trap(:INT) { server.shutdown }

server.start
