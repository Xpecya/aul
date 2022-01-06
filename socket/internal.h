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

// open api
int luaopen_aul_socket_internal(lua_State *L);
