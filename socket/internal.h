#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <sys/socket.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <netatalk/at.h>
#include <linux/ax25.h>
#include <netinet/in.h>
#include <netipx/ipx.h>
#include <sys/un.h>
#include <linux/x25.h>
#include <arpa/inet.h>

// create a socket
int internal_socket(lua_State *L);

// create a unix_socket pair
int internal_socketpair(lua_State *L);

// bind a socket to a fd
int internal_bind(lua_State *L);

// get socket's name
int internal_get_socket_name(lua_State *L);

// open a connection
int internal_connect(lua_State *L);

// get peer name
int internal_get_peer_name(lua_State *L);

// send data
int internal_send(lua_State *L);

// receive data
int internal_recv(lua_State *L);

// send to
int internal_send_to(lua_State *L);

// receive from
int internal_recv_from(lua_State *L);

// send message
int internal_send_msg(lua_State *L);

// receive message
int internal_recv_msg(lua_State *L);

// get socket option
int internal_get_sock_opt(lua_State *L);

// set socket option
int internal_set_sock_opt(lua_State *L);

// listen to a socket
int internal_listen(lua_State *L);

// accept from a socket
int internal_accept(lua_State *L);

// shutdown a socket
int internal_shutdown(lua_State *L);

// open api
int luaopen_aul_socket_internal(lua_State *L);
