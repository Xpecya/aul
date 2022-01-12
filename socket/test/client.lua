local Socket = require "aul.socket.socket";

local socketFD = Socket.socket("AF_INET", "SOCK_STREAM", "IPPROTO_TCP");
print("debug: socketFD = " .. socketFD);
Socket.connect(socketFD, {
    type = "sockaddr_in",
    sin_family = "AF_INET",
    sin_addr = {
        s_addr = "127.0.0.1"
    },
    sin_port = 9527
});
local data = Socket.recv(socketFD, 1024, 0);
print("data from server: " .. data);
