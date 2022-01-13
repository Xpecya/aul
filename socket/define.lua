-- @requirement: MetatableBuilder
-- @author: xpecya

local MetatableBuilder = require "aul.metatableBuilder.MetatableBuilder";

local ipProtocol = {
    IPPROTO_IP = 0, -- dummy protocol for TCP
    IPPROTO_ICMP = 1, -- internet control message protocol
    IPPROTO_IGMP = 2, -- internet group management protocol
    IPPROTO_IPIP = 4, -- IPIP tunnels(older KA9Q tunnels use 94)
    IPPROTO_TCP = 6, -- transmission control protocol
    IPPROTO_EGP = 8, -- exterior gateway protocol
    IPPROTO_PUP = 12, -- PUP protocol
    IPPROTO_UDP = 17, -- user datagram protocol
    IPPROTO_IDP = 22, -- XNS IDP protocol
    IPPROTO_TP = 29, -- SO transport protocol class 4
    IPPROTO_DCCP = 33, -- datagram congestion control protocol
    IPPROTO_IPV6 = 41, -- IPV6 header
    IPPROTO_RSVP = 46, -- reservation protocol
    IPPROTO_GRE = 47, -- general routing encapsulation
    IPPROTO_ESP = 50, -- encapsulation security payload
    IPPROTO_AH = 51, -- authentication header
    IPPROTO_MTP = 92, -- multicast transport protocol
    IPPROTO_BEETPH = 94, -- IP option pseudo header for BEET
    IPPROTO_ENCAP = 98, -- encapsulation header
    IPPROTO_PIM = 103, -- protocol independent multicast
    IPPROTO_COMP = 108, -- compression header protocol
    IPPROTO_SCTP = 132, -- stream control transmission protocol
    IPPROTO_UDPLITE = 136, -- UDP lite protocol
    IPPROTO_MPLS = 137, -- MPLS in IP
    IPPROTO_RAW = 255 -- raw IP packets
};

local socketType = {
    SOCK_STREAM = 1, -- sequenced, reliable, connection-based byte streams
    SOCK_DRAM = 2, -- connectionless, unreliable datagrams of fixed maximum length
    SOCK_RAW = 3, -- raw protocol interface
    SOCK_RDM = 4, -- reliably-delivered messages
    SOCK_SEQPACKET = 5, -- sequenced, reliable connection-based datagrams of fixed maximum length
    SOCK_DCCP = 6, -- datagram congestion control protocol
    SOCK_PACKET = 10, -- linux specific way of getting packets at the dev level
    SOCK_CLOEXEC = 524288, -- atomically set close-on-exec flag for the new descriptors
    SOCK_NONBLOCK = 2048 -- atomically mark descriptors as non-blocking
};

protocolFamily = {
    PF_LOCAL = 1,
    PF_NETLINK = 16
}

protocolFamily = {
    PF_UNSPEC = 0, -- unspecified
    PF_LOCAL = 1, -- local to host (pipes and file-domain)
    PF_UNIX = protocolFamily.PF_LOCAL,
    PF_FILE = protocolFamily.PF_LOCAL,
    PF_INET = 2, -- IP protocol family
    PF_AX25 = 3, -- amateur ratio AX.25
    PF_IPX = 4, -- novell internet protocol
    PF_APPLETALK = 5, -- apple talk ddp
    PF_NETROM = 6, -- amateur radio netROM
    PF_BRIDGE = 7, -- multiprotocol bridge
    PF_ATMPVC = 8, -- ATM PVC
    PF_X25 = 9, -- reserved for x.25 project
    PF_INET6 = 10, -- IP version 6
    PF_ROSE = 11, -- amateur radio x.25 PLP
    PF_DECnet = 12, -- reserved for DECnet project
    PF_NETBEUI = 13, -- reserved for 802.2LLC project
    PF_SECURITY = 14, -- security callback pseudo AF
    PF_KEY = 15, -- PF_KEY key management API
    PF_NETLINK = 16,
    PF_ROUTE = protocolFamily.PF_NETLINK, -- alias to emulate 4.4BSD
    PF_PACKET = 17, -- packet family
    PF_ASH = 18, -- ash
    PF_ECONET = 19, -- acorn econet
    PF_ATMSVC = 20, -- ATM SVC
    PF_RDS = 21, -- RDS sockets
    PF_SNA = 22, -- linux SNA project
    PF_IRDA = 23, -- IRDA sockets
    PF_PPPOX = 24, -- PPPoX sockets
    PF_WANPIPE = 25, -- wanpipe API sockets
    PF_LLC = 26, -- linux LLC
    PF_IB = 27, -- native infiniband address
    PF_MPLS = 28, -- MPLS
    PF_CAN = 29, -- controller area network
    PF_TIPC = 30, -- TIPC sockets
    PF_BLUETOOTH = 31, -- bluetooth sockets
    PF_IUCV = 32, -- IUCV sockets
    PF_RXRPC = 33, -- RxRPC sockets
    PF_ISDN = 34, -- mISDN sockets
    PF_PHONET = 35, -- phonet sockets
    PF_IEEE802154 = 36, -- IEEE 802.15.4 sockets
    PF_CAIF = 37, -- CAIF sockets
    PF_ALG = 38, -- algorithm sockets
    PF_NFC = 39, -- NFC sockets
    PF_VSOCK = 40, -- vSockets
    PF_KCM = 41, -- kernel connection multiplexor
    PF_QIPCRTR = 42, -- qualcomm IPC router
    PF_SMC = 43, -- SMC sockets
    PF_XDP = 44, -- XDP sockets
    PF_MAX = 45 -- max value for now...
};

local addressFamily = {
    AF_UNSPEC = protocolFamily.PF_UNSPEC,
    AF_LOCAL = protocolFamily.PF_LOCAL,
    AF_UNIX = protocolFamily.PF_UNIX,
    AF_FILE = protocolFamily.PF_FILE,
    AF_INET = protocolFamily.PF_INET,
    AF_AX25 = protocolFamily.PF_AX25,
    AF_IPX = protocolFamily.PF_IPX,
    AF_APPLETALK = protocolFamily.PF_APPLETALK,
    AF_NETROM = protocolFamily.PF_NETROM,
    AF_BRIDGE = protocolFamily.PF_BRIDGE,
    AF_ATMPVC = protocolFamily.PF_ATMPVC,
    AF_X25 = protocolFamily.PF_X25,
    AF_INET6 = protocolFamily.PF_INET6,
    AF_ROSE = protocolFamily.PF_ROSE,
    AF_DECnet = protocolFamily.PF_DECnet,
    AF_NETBEUI = protocolFamily.PF_NETBEUI,
    AF_SECURITY = protocolFamily.PF_SECURITY,
    AF_KEY = protocolFamily.PF_KEY,
    AF_NETLINK = protocolFamily.PF_NETLINK,
    AF_ROUTE = protocolFamily.PF_ROUTE,
    AF_PACKET = protocolFamily.PF_PACKET,
    AF_ASH = protocolFamily.PF_ASH,
    AF_ECONET = protocolFamily.PF_ECONET,
    AF_ATMSVC = protocolFamily.PF_ATMSVC,
    AF_RDS = protocolFamily.PF_RDS,
    AF_SNA = protocolFamily.PF_SNA,
    AF_IRDA = protocolFamily.PF_IRDA,
    AF_PPPOX = protocolFamily.PF_PPPOX,
    AF_WANPIPE = protocolFamily.PF_WANPIPE,
    AF_LLC = protocolFamily.PF_LLC,
    AF_IB = protocolFamily.PF_IB,
    AF_MPLS = protocolFamily.PF_MPLS,
    AF_CAN = protocolFamily.PF_CAN,
    AF_TIPC = protocolFamily.PF_TIPC,
    AF_BLUETOOTH = protocolFamily.PF_BLUETOOTH,
    AF_IUCV = protocolFamily.PF_IUCV,
    AF_RXRPC = protocolFamily.PF_RXRPC,
    AF_ISDN = protocolFamily.PF_ISDN,
    AF_PHONET = protocolFamily.PF_PHONET,
    AF_IEEE802154 = protocolFamily.PF_IEEE802154,
    AF_CAIF = protocolFamily.PF_CAIF,
    AF_ALG = protocolFamily.PF_ALG,
    AF_NFC = protocolFamily.PF_NFC,
    AF_VSOCK = protocolFamily.PF_VSOCK,
    AF_KCM = protocolFamily.PF_KCM,
    AF_QIPCRTR = protocolFamily.PF_QIPCRTR,
    AF_SMC = protocolFamily.PF_SMC,
    AF_XDP = protocolFamily.PF_XDP,
    AF_MAX = protocolFamily.PF_MAX
};

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

local flagEnum = {
    MSG_OOB = 0x01,
    MSG_PEEK = 0x02,
    MSG_DONTROUTE = 0x04,
    MSG_TRYHARD	= 0x04,
    MSG_CTRUNC = 0x08,
    MSG_PROXY = 0x10,
    MSG_TRUNC = 0x20,
    MSG_DONTWAIT = 0x40,
    MSG_EOR	= 0x80,
    MSG_WAITALL	= 0x100,
    MSG_FIN	= 0x200,
    MSG_SYN	= 0x400,
    MSG_CONFIRM	= 0x800,
    MSG_RST	= 0x1000,
    MSG_ERRQUEUE = 0x2000,
    MSG_NOSIGNAL = 0x4000,
    MSG_MORE = 0x8000,
    MSG_WAITFORONE = 0x10000,
    MSG_BATCH = 0x40000,
    MSG_ZEROCOPY = 0x4000000,
    MSG_FASTOPEN = 0x20000000,
    MSG_CMSG_CLOEXEC = 0x40000000
};

-- in order not to add anything in the global
local protocolFamilyLocal = protocolFamily;
protocolFamily = nil;

return setmetatable({}, MetatableBuilder.new().immutable().index({
    getDomain = function(domainName)
        assert(domainName ~= nil, "domain name is nil!");
        local result;
        if string.find(domainName, "PF") == 1 then
            result = protocolFamilyLocal[domainName];
        else
            result = addressFamily[domainName];
        end;
        assert(result ~= nil, "cannot find the domain specified with name " .. domainName)
        return result;
    end,
    getType = function(typeName)
        assert(typeName ~= nil, "type name is nil!");
        local result = socketType[typeName];
        assert(result ~= nil, "cannot find the type specified with name " .. typeName);
        return result;
    end,
    getProtocol = function(protocolName)
        assert(protocolName ~= nil, "protocol name is nil!");
        local result = ipProtocol[protocolName];
        assert(result ~= nil, "cannot find the ip protocol specified with name " .. protocolName);
        return result;
    end,
    bindTypeCheck = function(sockaddr)
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
    end,
    getFlag = function(flagName)
        return flagEnum[flagName];
    end
}).build());
