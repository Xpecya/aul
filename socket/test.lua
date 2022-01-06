local Socket = require "aul.socket.socket";

local socket = Socket.socket("AF_INET", "SOCK_STREAM", 0);
Socket.bind(socket, {
    type = "sockaddr_in",
    sin_family = "AF_INET",
    sin_port = 12306,
    sin_addr = {
        s_addr = "127.0.0.1"
    }
});

local address, length = Socket.getsockname(socket, "sockaddr_in");
--print("length = " .. length);
for k, v in pairs(address) do
    if type(v) == "table" then
        print(string.format("%s = {\r\n\t%s = %s\r\n}", "v.s_addr", k, v.s_addr));
    else
        print(k .. " = " .. v);
    end
end
