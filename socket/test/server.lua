local Socket = require "aul.socket.socket";

local socketFD = Socket.socket("AF_INET", "SOCK_STREAM", "IPPROTO_TCP");
print("debug: socketFD = " .. socketFD);
Socket.bind(socketFD, {
    type = "sockaddr_in",
    sin_family = "AF_INET",
    sin_addr = {
        s_addr = "127.0.0.1"
    },
    sin_port = 9527
});
Socket.listen(socketFD, 10);
local clientSocketFD = Socket.accept(socketFD);
print("debug: clientSocketFD = " .. clientSocketFD);
Socket.send(clientSocketFD, "Hello World!", 0);
