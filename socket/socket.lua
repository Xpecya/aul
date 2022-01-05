-- @requirements: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

-- for internal using only
local define = require "aul.socket.define";
local Internal = require "aul.socket.internal";

-- defined in sys/socket.h __SOCKADDR_ALLTYPES
local bindTypes = {
    "sockaddr",
    "sockaddr_at",
    "sockaddr_ax25",
    "sockaddr_dl",
    "sockaddr_eon",
    "sockaddr_in",
    "sockaddr_in6",
    "sockaddr_inarp",
    "sockaddr_ipx",
    "sockaddr_iso",
    "sockaddr_ns",
    "sockaddr_un",
    "sockaddr_x25"
};

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
        local socketAddressType = sockaddr.type;
        local notSupported = true;
        for _, v in ipairs(bindTypes) do
            if v == socketAddressType then
                notSupported = false;
                break;
            end
        end
        if notSupported then
            error("socket address type " .. socketAddressType .. "is not supported!");
        end

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
        Internal.bind(socket, sockaddr);
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
    end
}).build());
