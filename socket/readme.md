## Linux Socket

socket is the interface of <b>Linux Socket</b>, providing the availability to create, bind, and listen to a socket on <b>LINUX</b><br />
Windows socket is on to-do list.<br />
I'm trying to make the utils just the same as that on Linux C so there will NOT be any further abstractions and packages <br />
Just use it as the same as that on C<br />

## Support List

The following functions are currently supported:

    1. socket/create(domain: Number|String, socketType: Number|String, protocol: Number|String);
    2. socketpair(domain: Number|String, socketType: Number|String, protocol: Number|String, fileDescriptors: Table(optional));
    3. getsockname(socket: Number, sockaddr: Table);
    4. connect(socket: Number, sockaddr: Table);
    5. getpeername(socket: Number, socketType: String, sockaddr: Table(optional));
    6. send(socket: Number, data: String, flags: Number|Table);
    7. recv(socket: Number, length: Number, flags: Number|Table);
    8. sendto(socket: Number, data: Number, flags: Number|Table, target: Table);
    9. recvfrom(socket: Number, length: Number, flags: Number|Table, target: Table);
    10. listen(socket: Number, number: Number);
    11. accept(socket: Number);
    12. shutdown(socket: Number, how: Number|Table);
    13. getsockopt(socket: Number, level: Number|String, name: Number|String, length: Number, resultType: String, sockaddr: Table(optional));
    14. setsockopt(socket: Number, level: Number|String, name: Number|String, value: Any(except nil), length: Number);

The usage of each function is the same as that in socket.h<br />
Please feel free to have a try<br />
And please let me know if you find any problems or anything wrong or inconvenient<br />

## Create A Socket

    local socket = reuqire "aul.socket.socket";
    local socketFD = socket.craete("AF_INET", "SOCK_STREAM", "IPPROTO_TCP");

The create function returns a socket FD, which is a number in Lua, just like that in C.<br />
Notice that there isn't a #define macro in Lua, and I don't want to add anything globally, so you may use the string instead<br />
And the input string will be cast to number internally<br />
You can also use numbers directly:

    local socketFD = socket.create(2, 1, 6); -- which is the same as the formar one

Besides, if you prefer the original function name in socket.h, which is "socket":

    local socketFD = socket.socket("AF_INET", "SOCK_STREAM", "IPPROTO_TCP"); -- which is also the same as the formar one

All Linux sockets are supported, like AF_INET, AF_UNIX, AF_INET6, AF_AX25 etc... and also macros starts with PF is also supported<br />
And SOCK_STREAM, SOCK_DRAM, SOCK_RAW etc... <br />
And IPPROTO_TCP, IPPROTO_IP, IPPROTO_UDP, IPPROTO_RAW etc... <br />
In a word, EVERYTHING's supported. Just enjoy and have a try.<br />

I'm thinking about whether it's proper to add a function to add the defines globally and make the socket used like this:

    local socketFD = socket.global().socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

Which means many global variables will be added, like "AF_INET = 2", "SOCK_STREAM = 1" etc ...<br />
Your options are welcome.<br />

you may cast a file fd to a FILE* with aul-standard:

    local file = require "aul.standard.file";
    local socketFile = file.fdopen(socketFD, "rw");

Then you get a Lua-File, which contains the standard file functions, like socketFile:lines(), socketFile:write() etc ...<br />
But, as written in standard/readme.md, the fdopen function is also <b>LINUX ONLY</b>

I'm not going to describe all the interfaces in aul-socket in the following article, which may make this readme too long<br />
You may find the usage of all the functions' details defined in socket.h in the official Linux documentation<br />
Instead, I'm going to tell you the differences between socket in C and in aul<br />

## Create A Socket Pair

The socketpair function defined in socket.h will create two unix-sockets, and bind them to each other<br />
In C, you need to pass an array for the returning sockets, for there's no way to return two values in one function in C<br />
But it's supported in Lua, so the socketpair function can be used like this:

    local socket1, socket2 = socket.socketpair("AF_UNIX", "SOCK_STREAM", 0);

The C-typed usage is also supported:

    local socketFDs = {};
    socket.socketpair("AF_UNIX", "SOCK_STREAM", 0, socketFDs);
    local socket1 = socketFDs[1];
    local socket2 = socketFDs[2];

There are several interfaces with an optional table param using this logic.<br />
Which are the same as this one<br />

## Pass A Struct

Many functions in socket.h needs a struct pointer as the argument.<br />
And There's no way to do that directly<br />
In aul-socket, a struct is a table<br />
You pass a table to function and the function will cast the table to the struct internally<br />
For example, in the bind function:

    socket.bind(socketFD, {
        type = "sockaddr_in",
        sin_family = "AF_INET",
        sin_port = 1234,
        sin_addr = {
            s_addr = "127.0.0.1"
        }
    });

In this example, you can find that:

    1. you need to add a type in the table, which will tell aul-socket the struct type to trans
    2. you need to add the params in the table, with the name defined in the giving struct
    3. you don't need to call function ntohs and inet_ntoa, which is resolved internally

There are several functions which a struct pointer is needed, and the param type is table<br />
Which are the same as this one<br />

## Flags

Some functions need to send a number as a param called flags(or 'how' in shutdown function).<br />
Like: send, recv etc ... <br />
In C, with the binary operator, you can easily send multiple options with |<br />
Like MSG_DONTROUTE | MSG_ZEROCOPY<br />
In Lua, since version 5.1 is still wildly used and there's no binary operator in this version<br />
It is allowed to send multiple flags in a table like {"MSG_DONTROUTE", "MSG_ZEROCOPY"} in Lua 5.1<br />
And in Lua 5.3 and higher, as long as the global function is still not yet supported, you have to use the same way as that in 5.1<br />
You may use something similar in C in the future if I finally decide to develop the global function<br />
