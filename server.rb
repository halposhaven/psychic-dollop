require 'socket'                                         
require 'thread'

delay=ENV['delaySeconds'].to_i
hosts=ENV['hostList']


## Outbound actions
Thread.new do
  loop do
    hosts.split(",").each do |h|
      host, port = h.split(":")
      puts "trying #{host} on #{port}"
      poller = TCPSocket.open(host, port.to_i)                 
      request = "GET /ping HTTP/1.0\r\n\r\n"
      poller.print(request) 
      response = poller.read
      header ,body = response.split("\r\n\r\n", 2) 
      print body 
    end
    sleep delay
  end
end


## Listen Server 
  listener = TCPServer.new(1616)                               
  loop do                                                  
    client = listener.accept                                 
    bulkInfo = client.gets                               
    what, where, _ = bulkInfo.split                       
    if what == 'GET'                                       
      if result = where.match(/^\/ping/)         
        response = "HTTP/1.1 200\r\n\r\npong\\n"
        client.puts(response)                              
      end                                                  
    end                                                    
    client.close                                           
  end                                                      
  socket.close 
