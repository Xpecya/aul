-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

-- for internal using only
local define = require "aul.socket.define";
local Internal = require "aul.socket.internal";

local function getDomain(domain)
    assert(domain ~= nil, "domain is nil!");
    if type(domain) == "string" then
        domain = define.getDomain(domain);
    elseif type(domain) ~= "number" then
        error("domain must be either string or number!");
    end
    return domain;
end

local function getSocketParams(domain, socketType, protocol)
    assert(socketType ~= nil, "type is nil!");
    assert(protocol ~= nil, "protocol is nil!");

    if type(socketType) == "string" then
        socketType = define.getType(socketType);
    elseif type(socketType) ~= "number" then
        error("type must be either string or number!");
    end
    if type(protocol) == "string" then
        protocol = define.getProtocol(protocol);
    elseif type(protocol) ~= "number" then
        error("protocol must be either string or number!");
    end

    return getDomain(domain), socketType, protocol;
end

local function toStructParam(socket, sockaddr)
    define.bindTypeCheck(sockaddr);
    if sockaddr.type == "sockaddr" and type(sockaddr.sa_family) == "string" then
        sockaddr.sa_family = getDomain(sockaddr.sa_family);
    elseif sockaddr.type == "sockaddr_at" and type(sockaddr.sat_family) == "string" then
        sockaddr.sat_family = getDomain(sockaddr.sat_family);
    elseif sockaddr.type == "sockaddr_ax25" and type(sockaddr.sax25_family) == "string" then
        sockaddr.sax25_family = getDomain(sockaddr.sax25_family);
    elseif sockaddr.type == "sockaddr_dl" and type(sockaddr.sa_family) == "string" then
        sockaddr.sa_family = getDomain(sockaddr.sa_family);
    elseif sockaddr.type == "sockaddr_eon" and type(sockaddr.sa_family) == "string" then
        sockaddr.sa_family = getDomain(sockaddr.sa_family);
    elseif sockaddr.type == "sockaddr_in" and type(sockaddr.sin_family) == "string" then
        sockaddr.sin_family = getDomain(sockaddr.sin_family);
    elseif sockaddr.type == "sockaddr_in6" and type(sockaddr.sin6_family) == "string" then
        sockaddr.sin6_family = getDomain(sockaddr.sin6_family);
    elseif sockaddr.type == "sockaddr_inarp" and type(sockaddr.sa_family) == "string" then
        sockaddr.sa_family = getDomain(sockaddr.sa_family);
    elseif sockaddr.type == "sockaddr_ipx" and type(sockaddr.sipx_family) == "string" then
        sockaddr.sipx_family = getDomain(sockaddr.sipx_family);
    elseif sockaddr.type == "sockaddr_iso" and type(sockaddr.sa_family) == "string" then
        sockaddr.sa_family = getDomain(sockaddr.sa_family);
    elseif sockaddr.type == "sockaddr_ns" and type(sockaddr.sa_family) == "string" then
        sockaddr.sa_family = getDomain(sockaddr.sa_family);
    elseif sockaddr.type == "sockaddr_un" and type(sockaddr.sun_family) == "string" then
        sockaddr.sun_family = getDomain(sockaddr.sun_family);
    end
    return socket, sockaddr;
end

local function flag2Number(flagString)
    local result = define.getFlag(flagString);
    if result == nil then
        error("unknown flag type " .. flagString);
    end
    return result;
end

local function getFlags(flags, acceptTable)
    local flagsType = type(flags);
    local flagData;
    if flagsType == "number" then
        flagData = flags;
    elseif flagsType == "string" then
        flagData = flag2Number(flags);
    elseif acceptTable and flagsType == "table" then
        flagData = {};
        for _, v in ipairs(flags) do
            table.insert(flagData, getFlags(v, false));
        end
    else
        error("illegal flags type! expect number, string or table-array with number and string!");
    end
    return flagData;
end

return setmetatable({}, MetatableBuilder.new().immutable().index({
    socket = function(domain, socketType, protocol)
        return Internal.socket(getSocketParams(domain, socketType, protocol));
    end,
    socketpair = function(domain, socketType, protocol, fileDescriptors)
        local fd1, fd2 = Internal.socketpair(getSocketParams(domain, socketType, protocol));
        if type(fileDescriptors) == "table" then
            fileDescriptors[1] = fd1;
            fileDescriptors[2] = fd2;
        else
            return fd1, fd2;
        end
    end,
    bind = function(socket, sockaddr)
        Internal.bind(toStructParam(socket, sockaddr));
    end,
    getsockname = function(socket, socketType, sockaddr)
        assert(type(socket) == "number", "socket is not a number!");
        if type(socketType) ~= "string" then
            socketType = "sockaddr";
        end

        local address, length = Internal.getsockname(socket, socketType);
        if type(sockaddr) == "table" then
            for i, v in pairs(address) do
                sockaddr[i] = v;
            end
            return length;
        end
        return address, length;
    end,
    connect = function(socket, sockaddr)
        Internal.connect(toStructParam(socket, sockaddr));
    end,
    getpeername = function(socket, socketType, sockaddr)
        assert(type(socket) == "number", "socket is not a number!");
        if type(socketType) ~= "string" then
            socketType = "sockaddr";
        end

        local address, length = Internal.getpeername(socket, socketType);
        if type(sockaddr) == "table" then
            for i, v in pairs(address) do
                sockaddr[i] = v;
            end
            return length;
        end
        return address, length;
    end,
    send = function(socket, data, flags)
        assert(type(socket) == "number", "socket is not a number!");
        assert(type(data) == "string", "send data is not a string!");
        flags = getFlags(flags, true);
        return Internal.send(socket, data, flags);
    end,
    recv = function(socket, length, flags)
        assert(type(socket) == "number", "socket is not a number!");
        assert(type(length) == "number", "length is not a number!");
        flags = getFlags(flags, true);
        return Internal.recv(socket, length, flags);
    end,
    sendto = function(socket, data, flags, target)
        assert(type(data) == "string", "send data is not a string!");
        flags = getFlags(flags, true);
        socket, target = toStructParam(socket, target);
        return Internal.sendto(socket, target, data, flags);
    end,
    listen = function(socket, number)
        assert(type(socket) == "number", "socket is not a number!");
        assert(type(number) == "number", "queue size is not a number!");
        Internal.listen(socket, number);
    end,
    accept = function(socket)
        assert(type(socket) == "number", "socket is not a number!");
        return Internal.accept(socket);
    end
}).build());
