require 'socket'
require 'erb'
require 'rack'

PORT = 5678

server = TCPServer.new PORT

puts "Victim server is online | http://localhost:#{PORT}"

loop do
  session = server.accept
  request = session.gets
  puts request

  _method, full_path = request.split(' ')
  _path, query = full_path.split('?')
  query_params = Rack::Utils.parse_nested_query(query)

  session.print "HTTP/2.0 200\r\n"
  session.print "Content-Type: text/html\r\n"
  session.print "Content-Security-Policy: script-src 'self';\r\n"
  session.print "Set-Cookie: token=any-secret-token\r\n"
  session.print "\r\n"
  session.print "Hello #{ERB::Util.html_escape query_params['name']}! The time is #{Time.now}"

  session.close
end
