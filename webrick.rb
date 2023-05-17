# frozen_string_literal: true

require 'webrick'
require 'date'

config = {
  DocumentRoot: './',
  BindAddress: '127.0.0.1',
  Port: 8099
}

server = WEBrick::HTTPServer.new(config)

head_el = '<head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>'

server.mount_proc('/testprog') do |req, res|
  res.body << '<html lang="ja">'
  res.body << head_el
  res.body << '<body>'
  res.body << "<p>アクセスした日は#{Date.today}です</p>"
  res.body << "<p>リクエストのパスは#{req.path}でした。</p>"
  res.body << '<table border="1">'
  req.each do |key, value|
    res.body << '<tr>'
    res.body << "<td>#{key}</td>"
    res.body << "<td>#{value}</td>"
    res.body << '</tr>'
  end
  res.body << '</table>'
  res.body << '</body>'
  res.body << '</html>'
end

trap(:INT) { server.shutdown }

server.start

if __FILE__ == $PROGRAM_NAME
  app = OrderHistoryWebApp.new(ARGV)
  app.run
end
