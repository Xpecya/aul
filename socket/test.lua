local Socket = require "aul.socket.socket";

local socket = Socket.socket("AF_INET", "SOCK_STREAM", 0);
print("socket = " .. socket);
local address, length = Socket.getsockname(socket);
print("length = " .. length);
--print("address = " .. address);
for i, v in pairs(address) do
    print(i .. ": " .. v);
end
