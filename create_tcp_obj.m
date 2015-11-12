%tcp_obj - Opens a TCP connection and returns the TCP object
%Inputs:    IP - IP Address
%           Port - Port Number
%           BufferSize - Size of the TCP buffer in bytes

function tcp_obj = create_tcp_obj(IP,Port,BufferSize)

tcp_obj = tcpip(IP, Port);
tcp_obj.InputBufferSize = BufferSize;

end


