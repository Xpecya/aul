#include "internal.h"

extern int errno;

int internal_socket(lua_State *L) {
  int domain = lua_tointeger(L, 1);
  int type = lua_tointeger(L, 2);
  int protocol = lua_tointeger(L, 3);

  errno = 0;
  int result = socket(domain, type, protocol);
  if (result == -1) {
    char text[1024];
    sprintf(text, "error code: %d, error message: %s\r\n", errno, strerror(errno));
    luaL_error(L, text);
    return 0;
  }
  lua_pushinteger(L, (lua_Integer) result);
  return 1;
}

int internal_socketpair(lua_State *L) {
    int domain = lua_tointeger(L, 1);
    int type = lua_tointeger(L, 2);
    int protocol = lua_tointeger(L, 3);
    int fds[2];

    errno = 0;
    int result = socketpair(domain, type, protocol, fds);
    if (result == -1) {
      char text[1024];
      sprintf(text, "error code: %d, error message: %s\r\n", errno, strerror(errno));
      luaL_error(L, text);
      return 0;
    }
    lua_pushinteger(L, (lua_Integer) fds[0]);
    lua_pushinteger(L, (lua_Integer) fds[1]);
    return 2;
}

void internal_to_sockaddr(lua_State *L, struct sockaddr *address) {
  int field_type = lua_getfield(L, 2, "sa_family");
  if (field_type == LUA_TNUMBER) {
    int sa_family = lua_tointeger(L, 4);
    address -> sa_family = sa_family;
  }

  field_type = lua_getfield(L, 2, "sa_data");
  if (field_type == LUA_TSTRING) {
    const char *sa_data = lua_tostring(L, 5);
    memcpy(address -> sa_data, sa_data, sizeof(address -> sa_data));
  }
}

void internal_to_sockaddr_in(lua_State *L, struct sockaddr *address) {
  struct sockaddr_in *sockaddr_in_t = (struct sockaddr_in*) address;

  int field_type = lua_getfield(L, 2, "sin_family");
  if (field_type == LUA_TNUMBER) {
    int sin_family = lua_tointeger(L, 4);
    sockaddr_in_t -> sin_family = sin_family;
  }

  field_type = lua_getfield(L, 2, "sin_port");
  if (field_type == LUA_TNUMBER) {
    int sin_port = lua_tointeger(L, 5);
    sockaddr_in_t -> sin_port = htons(sin_port);
  }

  field_type = lua_getfield(L, 2, "sin_addr");
  if (field_type == LUA_TTABLE) {
      field_type = lua_getfield(L, 6, "s_addr");
      if (field_type == LUA_TNUMBER) {
        int s_addr = lua_tointeger(L, 7);
        sockaddr_in_t -> sin_addr.s_addr = s_addr;
      } else if (field_type == LUA_TSTRING) {
        const char *s_addr = lua_tostring(L, 7);
        sockaddr_in_t -> sin_addr.s_addr = inet_addr(s_addr);
      }
  }
}

void internal_to_sockaddr_un(lua_State *L, struct sockaddr *address) {
  struct sockaddr_un *sockaddr_un_t = (struct sockaddr_un*) address;

  int field_type = lua_getfield(L, 2, "sun_family");
  if (field_type == LUA_TNUMBER) {
    int sun_family = lua_tointeger(L, 4);
    sockaddr_un_t -> sun_family = sun_family;
  }

  field_type = lua_getfield(L, 2, "sun_path");
  if (field_type == LUA_TSTRING) {
    const char *sun_path = lua_tostring(L, 5);
    memcpy(sockaddr_un_t -> sun_path, sun_path, sizeof(sockaddr_un_t -> sun_path));
  }
}

// though defined in socket.h
// i can't find any usage of sockaddr_dl
// so far it is considered the same as sockaddr
// todo: finish this function
void internal_to_sockaddr_ns(lua_State *L, struct sockaddr *address) {
  internal_to_sockaddr(L, address);
}

// though defined in socket.h
// i can't find any usage of sockaddr_dl
// so far it is considered the same as sockaddr
// todo: finish this function
void internal_to_sockaddr_dl(lua_State *L, struct sockaddr *address) {
  internal_to_sockaddr(L, address);
}

void internal_to_sockaddr_at(lua_State *L, struct sockaddr *address) {
  struct sockaddr_at *sockaddr_at_t = (struct sockaddr_at*) address;

  int field_type = lua_getfield(L, 2, "sat_family");
  if (field_type == LUA_TNUMBER) {
    int sat_family = lua_tointeger(L, 4);
    sockaddr_at_t -> sat_family = sat_family;
  }

  field_type = lua_getfield(L, 2, "sat_port");
  if (field_type == LUA_TNUMBER) {
    int sat_port = lua_tointeger(L, 5);
    sockaddr_at_t -> sat_port = sat_port;
  }

  field_type = lua_getfield(L, 2, "sat_addr");
  if (field_type == LUA_TTABLE) {
      field_type = lua_getfield(L, 6, "s_net");
      if (field_type == LUA_TNUMBER) {
        int s_net = lua_tointeger(L, 7);
        sockaddr_at_t -> sat_addr.s_net = s_net;
      }

      field_type = lua_getfield(L, 6, "s_node");
      if (field_type == LUA_TNUMBER) {
        int s_node = lua_tointeger(L, 8);
        sockaddr_at_t -> sat_addr.s_node = s_node;
      }
  }
}

void internal_to_sockaddr_in6(lua_State *L, struct sockaddr *address) {
  struct sockaddr_in6 *sockaddr_in6_t = (struct sockaddr_in6*) address;

  int field_type = lua_getfield(L, 2, "sin6_family");
  if (field_type == LUA_TNUMBER) {
    int sin6_family = lua_tointeger(L, 4);
    sockaddr_in6_t -> sin6_family = sin6_family;
  }

  field_type = lua_getfield(L, 2, "sin6_port");
  if (field_type == LUA_TNUMBER) {
    int sin6_port = lua_tointeger(L, 5);
    sockaddr_in6_t -> sin6_port = sin6_port;
  }

  field_type = lua_getfield(L, 2, "sin6_flowinfo");
  if (field_type == LUA_TNUMBER) {
    int sin6_flowinfo = lua_tointeger(L, 6);
    sockaddr_in6_t -> sin6_flowinfo = sin6_flowinfo;
  }

  field_type = lua_getfield(L, 2, "sin6_scope_id");
  if (field_type == LUA_TNUMBER) {
    int sin6_scope_id = lua_tointeger(L, 7);
    sockaddr_in6_t -> sin6_scope_id = sin6_scope_id;
  }

  field_type = lua_getfield(L, 2, "sin6_addr");
  if (field_type == LUA_TTABLE) {
    field_type = lua_getfield(L, 8, "__in6_u");
    if (field_type == LUA_TTABLE) {
      field_type = lua_getfield(L, 9, "__u6_addr8");
      if (field_type == LUA_TTABLE) {
        for(int i = 0; i < 16; i ++) {
          sockaddr_in6_t -> sin6_addr.__in6_u.__u6_addr8[i] = lua_geti(L, 10, i + 1);
        }
      } else {
        field_type = lua_getfield(L, 9, "__u6_addr16");
        if (field_type == LUA_TTABLE) {
          for (int i = 0; i < 8; i ++) {
            sockaddr_in6_t -> sin6_addr.__in6_u.__u6_addr16[i] = lua_geti(L, 11, i + 1);
          }
        } else {
          field_type = lua_getfield(L, 9, "__u6_addr32");
          if (field_type == LUA_TTABLE) {
            for (int i = 0; i < 4; i ++) {
              sockaddr_in6_t -> sin6_addr.__in6_u.__u6_addr32[i] = lua_geti(L, 12, i + 1);
            }
          }
        }
      }
    }
  } else if (field_type == LUA_TSTRING) {
    const char *ipv6_address = lua_tostring(L, 8);
    inet_pton(AF_INET6, ipv6_address, &sockaddr_in6_t -> sin6_addr);
  }
}

void internal_to_sockaddr_ipx(lua_State *L, struct sockaddr *address) {
  struct sockaddr_ipx *sockaddr_ipx_t = (struct sockaddr_ipx*) address;

  int field_type = lua_getfield(L, 2, "sipx_family");
  if (field_type == LUA_TNUMBER) {
    int sipx_family = lua_tointeger(L, 4);
    sockaddr_ipx_t -> sipx_family = sipx_family;
  }

  field_type = lua_getfield(L, 2, "sipx_port");
  if (field_type == LUA_TNUMBER) {
    int sipx_port = lua_tointeger(L, 5);
    sockaddr_ipx_t -> sipx_port = sipx_port;
  }

  field_type = lua_getfield(L, 2, "sipx_network");
  if (field_type == LUA_TNUMBER) {
    int sipx_network = lua_tointeger(L, 6);
    sockaddr_ipx_t -> sipx_network = sipx_network;
  }

  field_type = lua_getfield(L, 2, "sipx_type");
  if (field_type == LUA_TNUMBER) {
    int sipx_type = lua_tointeger(L, 7);
    sockaddr_ipx_t -> sipx_type = sipx_type;
  }

  field_type = lua_getfield(L, 2, "sipx_node");
  if (field_type == LUA_TSTRING) {
    const char *sipx_node = lua_tostring(L, 8);
    memcpy(sockaddr_ipx_t -> sipx_node, sipx_node, sizeof(sockaddr_ipx_t -> sipx_node));
  }
}

// though defined in socket.h
// i can't find any usage of sockaddr_eon
// so far it is considered the same as sockaddr
// todo: finish this function
int internal_to_sockaddr_iso(lua_State *L, struct sockaddr *address) {
  internal_to_sockaddr(L, address);
}

// though defined in socket.h
// i can't find any usage of sockaddr_eon
// so far it is considered the same as sockaddr
// todo: finish this function
void internal_to_sockaddr_eon(lua_State *L, struct sockaddr *address) {
  internal_to_sockaddr(L, address);
}

void internal_to_sockaddr_x25(lua_State *L, struct sockaddr *address) {
  struct sockaddr_x25 *sockaddr_x25_t = (struct sockaddr_x25*) address;

  int field_type = lua_getfield(L, 2, "sx25_addr");
  if (field_type == LUA_TTABLE) {
    field_type = lua_getfield(L, 3, "sx25_addr");
    if (field_type == LUA_TTABLE) {
      field_type = lua_getfield(L, 4, "x25_addr");
      if (field_type == LUA_TSTRING) {
        const char *x25_addr = lua_tostring(L, 5);
        memcpy(sockaddr_x25_t -> sx25_addr.x25_addr, x25_addr, sizeof(sockaddr_x25_t -> sx25_addr.x25_addr));
      }
    }
  }
}

void internal_to_sockaddr_ax25(lua_State *L, struct sockaddr *address) {
  struct sockaddr_ax25 *sockaddr_ax25_t = (struct sockaddr_ax25*) address;

  int field_type = lua_getfield(L, 2, "sax25_family");
  if (field_type == LUA_TNUMBER) {
    int sax25_family = lua_tointeger(L, 4);
    sockaddr_ax25_t -> sax25_family = sax25_family;
  }

  field_type = lua_getfield(L, 2, "sax25_ndigis");
  if (field_type == LUA_TNUMBER) {
    int sax25_ndigis = lua_tointeger(L, 5);
    sockaddr_ax25_t -> sax25_ndigis = sax25_ndigis;
  }

  field_type = lua_getfield(L, 2, "sax25_call");
  if (field_type == LUA_TTABLE) {
    field_type = lua_getfield(L, 6, "ax25_call");
    if (field_type == LUA_TSTRING) {
      const char *ax25_call = lua_tostring(L, 7);
      memcpy(sockaddr_ax25_t -> sax25_call.ax25_call, ax25_call, sizeof(sockaddr_ax25_t -> sax25_call.ax25_call));
    }
  }
}

// though defined in socket.h
// i can't find any usage of sockaddr_eon
// so far it is considered the same as sockaddr
// todo: finish this function
void internal_to_sockaddr_inarp(lua_State *L, struct sockaddr *address) {
  internal_to_sockaddr(L, address);
}

struct internal_addr {
  struct sockaddr address;
  int socket;
};

int internal_to_addr(lua_State *L, struct internal_addr *addr_t) {
  struct sockaddr address;
  memset(&address, 0, sizeof(address));

  int data_type = lua_type(L, 1);
  if (data_type != LUA_TNUMBER) {
    luaL_error(L, "the first argument of bind is not a number!");
    return -1;
  }
  int socket = lua_tointeger(L, 1);

  data_type = lua_type(L, 2);
  if (data_type != LUA_TTABLE) {
    luaL_error(L, "the second argument of bind is not a table!");
    return -1;
  }

  data_type = lua_getfield(L, 2, "type");
  if (data_type != LUA_TSTRING) {
    luaL_error(L, "table's type is not specified! It must be standard lua string!");
    return -1;
  }
  const char* type = lua_tostring(L, 3);

  int length = strlen(type);
  switch(length) {
    case 8: {
      internal_to_sockaddr(L, &address);
      break;
    }
    case 11: {
      if (strcmp("sockaddr_in", type) == 0) {
        internal_to_sockaddr_in(L, &address);
      } else if (strcmp("sockaddr_un", type) == 0) {
        internal_to_sockaddr_un(L, &address);
      } else if (strcmp("sockaddr_ns", type) == 0) {
        internal_to_sockaddr_ns(L, &address);
      } else if (strcmp("sockaddr_at", type) == 0) {
        internal_to_sockaddr_at(L, &address);
      } else {
        internal_to_sockaddr_dl(L, &address);
      }
      break;
    }
    case 12: {
      if (strcmp("sockaddr_in6", type) == 0) {
        internal_to_sockaddr_in6(L, &address);
      } else if (strcmp("sockaddr_ipx", type) == 0) {
        internal_to_sockaddr_ipx(L, &address);
      } else if (strcmp("sockaddr_iso", type) == 0) {
        internal_to_sockaddr_iso(L, &address);
      } else if (strcmp("sockaddr_x25", type) == 0) {
        internal_to_sockaddr_x25(L, &address);
      } else {
        internal_to_sockaddr_eon(L, &address);
      }
      break;
    }
    case 13: {
      internal_to_sockaddr_ax25(L, &address);
      break;
    }
    case 14: {
      internal_to_sockaddr_inarp(L, &address);
      break;
    }
  }
  addr_t -> address = address;
  addr_t -> socket = socket;
  return 0;
}

int internal_bind(lua_State *L) {
  struct internal_addr addr_t;
  memset(&addr_t, 0, sizeof(addr_t));
  int result = internal_to_addr(L, &addr_t);
  if (result == -1) {
    return 0;
  }

  errno = 0;
  result = bind(addr_t.socket, &addr_t.address, sizeof(addr_t.address));
  if (result == -1) {
    char text[1024];
    sprintf(text, "error code: %d, error message: %s\r\n", errno, strerror(errno));
    luaL_error(L, text);
  }
  return 0;
}

int internal_to_table_sockaddr(lua_State *L, struct sockaddr *address, int length) {
  lua_createtable(L, 0, 2);
  lua_pushinteger(L, address -> sa_family);
  lua_setfield(L, 3, "sa_family");
  lua_pushstring(L, address -> sa_data);
  lua_setfield(L, 3, "sa_data");
  lua_pushinteger(L, length);
  return 2;
}

int internal_to_table_sockaddr_in(lua_State *L, struct sockaddr *address, int length) {
  struct sockaddr_in *sockaddr_in_t = (struct sockaddr_in*) address;

  lua_createtable(L, 0, 3);
  lua_pushinteger(L, sockaddr_in_t -> sin_family);
  lua_setfield(L, 3, "sin_family");
  lua_pushinteger(L, ntohs(sockaddr_in_t -> sin_port));
  lua_setfield(L, 3, "sin_port");
  lua_createtable(L, 0, 1);
  lua_pushstring(L, inet_ntoa(sockaddr_in_t -> sin_addr));
  lua_setfield(L, 4, "s_addr");
  lua_setfield(L, 3, "sin_addr");
  lua_pushinteger(L, length);
  return 2;
}

int internal_to_table_sockaddr_un(lua_State *L, struct sockaddr *address, int length) {
  struct sockaddr_un *sockaddr_un_t = (struct sockaddr_un*) address;

  lua_createtable(L, 0, 2);
  lua_pushinteger(L, sockaddr_un_t -> sun_family);
  lua_setfield(L, 3, "sun_family");
  lua_pushstring(L, sockaddr_un_t -> sun_path);
  lua_setfield(L, 3, "sun_path");
  lua_pushinteger(L, length);
  return 2;
}

// just like internal_bind_sockaddr_ns
// todo: finish this function
int internal_to_table_sockaddr_ns(lua_State *L, struct sockaddr *address, int length) {
  return internal_to_table_sockaddr(L, address, length);
}

int internal_to_table_sockaddr_at(lua_State *L, struct sockaddr *address, int length) {
  struct sockaddr_at *sockaddr_at_t = (struct sockaddr_at*) address;

  lua_createtable(L, 0, 3);
  lua_pushinteger(L, sockaddr_at_t -> sat_family);
  lua_setfield(L, 3, "sat_family");
  lua_pushinteger(L, sockaddr_at_t -> sat_port);
  lua_setfield(L, 3, "sat_port");
  lua_createtable(L, 0, 2);
  lua_pushinteger(L, sockaddr_at_t -> sat_addr.s_net);
  lua_setfield(L, 4, "s_net");
  lua_pushinteger(L, sockaddr_at_t -> sat_addr.s_node);
  lua_setfield(L, 4, "s_node");
  lua_setfield(L, 3, "sat_addr");
  lua_pushinteger(L, length);
  return 2;
}

// just like internal_bind_sockaddr_dl
// todo: finish this function
int internal_to_table_sockaddr_dl(lua_State *L, struct sockaddr *address, int length) {
  struct sockaddr_ax25 *sockaddr_ax25_t = (struct sockaddr_ax25*) address;

  lua_createtable(L, 0, 3);
  lua_pushinteger(L, sockaddr_ax25_t -> sax25_family);
  lua_setfield(L, 3, "sax25_family");
  lua_pushinteger(L, sockaddr_ax25_t -> sax25_ndigis);
  lua_setfield(L, 3, "sax25_ndigis");
  lua_createtable(L, 0, 1);
  lua_pushstring(L, sockaddr_ax25_t -> sax25_call.ax25_call);
  lua_setfield(L, 4, "ax25_call");
  lua_setfield(L, 3, "sax25_call");
  lua_pushinteger(L, length);
  return 2;
}

int internal_to_table_sockaddr_in6(lua_State *L, struct sockaddr *address, int length) {
  struct sockaddr_in6 *sockaddr_in6_t = (struct sockaddr_in6*) address;

  lua_createtable(L, 0, 5);
  lua_pushinteger(L, sockaddr_in6_t -> sin6_family);
  lua_setfield(L, 3, "sin6_family");
  lua_pushinteger(L, sockaddr_in6_t -> sin6_port);
  lua_setfield(L, 3, "sin6_port");
  lua_pushinteger(L, sockaddr_in6_t -> sin6_flowinfo);
  lua_setfield(L, 3, "sin6_flowinfo");
  lua_pushinteger(L, sockaddr_in6_t -> sin6_scope_id);
  lua_setfield(L, 3, "sin6_scope_id");
  char ipv6_address[sizeof(sockaddr_in6_t -> sin6_addr)];
  inet_ntop(AF_INET6, &sockaddr_in6_t -> sin6_addr, ipv6_address, sizeof(sockaddr_in6_t -> sin6_addr));
  lua_pushstring(L, ipv6_address);
  lua_setfield(L, 3, "sin6_addr");
  lua_pushinteger(L, length);
  return 2;
}

int internal_to_table_sockaddr_ipx(lua_State *L, struct sockaddr *address, int length) {
  struct sockaddr_ipx *sockaddr_ipx_t = (struct sockaddr_ipx*) address;

  lua_createtable(L, 0, 5);
  lua_pushinteger(L, sockaddr_ipx_t -> sipx_family);
  lua_setfield(L, 3, "sipx_family");
  lua_pushinteger(L, sockaddr_ipx_t -> sipx_port);
  lua_setfield(L, 3, "sipx_port");
  lua_pushinteger(L, sockaddr_ipx_t -> sipx_network);
  lua_setfield(L, 3, "sipx_network");
  lua_pushinteger(L, sockaddr_ipx_t -> sipx_type);
  lua_setfield(L, 3, "sipx_type");
  lua_pushstring(L, sockaddr_ipx_t -> sipx_node);
  lua_setfield(L, 3, "sipx_node");
  lua_pushinteger(L, length);
  return 2;
}

// just like internal_bind_sockaddr_iso
// todo: finish this function
int internal_to_table_sockaddr_iso(lua_State *L, struct sockaddr *address, int length) {
  return internal_to_table_sockaddr(L, address, length);
}

int internal_to_table_sockaddr_x25(lua_State *L, struct sockaddr *address, int length) {
  struct sockaddr_x25 *sockaddr_x25_t = (struct sockaddr_x25*) address;

  lua_createtable(L, 0, 2);
  lua_pushinteger(L, sockaddr_x25_t -> sx25_family);
  lua_setfield(L, 3, "sx25_family");
  lua_createtable(L, 0, 1);
  lua_pushstring(L, sockaddr_x25_t -> sx25_addr.x25_addr);
  lua_setfield(L, 4, "x25_addr");
  lua_setfield(L, 3, "sx25_addr");
  lua_pushinteger(L, length);
  return 2;
}

// just like internal_bind_sockaddr_eon
// todo: finish this function
int internal_to_table_sockaddr_eon(lua_State *L, struct sockaddr *address, int length) {
  return internal_to_table_sockaddr(L, address, length);
}

// just like internal_bind_sockaddr_eon
// todo: finish this function
int internal_to_table_sockaddr_ax25(lua_State *L, struct sockaddr *address, int length) {
  return internal_to_table_sockaddr(L, address, length);
}

// just like internal_bind_sockaddr_inarp
// todo: finish this function
int internal_to_table_sockaddr_inarp(lua_State *L, struct sockaddr *address, int length) {
  return internal_to_table_sockaddr(L, address, length);
}

int internal_to_table(lua_State *L, struct sockaddr* address, socklen_t length) {
  const char *socket_type = lua_tostring(L, 2);
  switch (strlen(socket_type)) {
    case 8: {
      return internal_to_table_sockaddr(L, address, length);
    }
    case 11: {
      if (strcmp("sockaddr_in", socket_type) == 0) {
        return internal_to_table_sockaddr_in(L, address, length);
      }
      if (strcmp("sockaddr_un", socket_type) == 0) {
        return internal_to_table_sockaddr_un(L, address, length);
      }
      if (strcmp("sockaddr_ns", socket_type) == 0) {
        return internal_to_table_sockaddr_ns(L, address, length);
      }
      if (strcmp("sockaddr_at", socket_type) == 0) {
        return internal_to_table_sockaddr_at(L, address, length);
      }
      return internal_to_table_sockaddr_dl(L, address, length);
    }
    case 12: {
      if (strcmp("sockaddr_in6", socket_type) == 0) {
        return internal_to_table_sockaddr_in6(L, address, length);
      }
      if (strcmp("sockaddr_ipx", socket_type) == 0) {
        return internal_to_table_sockaddr_ipx(L, address, length);
      }
      if (strcmp("sockaddr_iso", socket_type) == 0) {
        return internal_to_table_sockaddr_iso(L, address, length);
      }
      if (strcmp("sockaddr_x25", socket_type) == 0) {
        return internal_to_table_sockaddr_x25(L, address, length);
      }
      return internal_to_table_sockaddr_eon(L, address, length);
    }
    case 13: {
      return internal_to_table_sockaddr_ax25(L, address, length);
    }
    case 14: {
      return internal_to_table_sockaddr_inarp(L, address, length);
    }
  }
}

int internal_get_socket_name(lua_State *L) {
  int socket = lua_tointeger(L, 1);
  struct sockaddr address;
  memset(&address, 0, sizeof(address));
  socklen_t length;

  errno = 0;
  int result = getsockname(socket, &address, &length);
  if (result == -1) {
    char text[1024];
    sprintf(text, "error code: %d, error message: %s\r\n", errno, strerror(errno));
    luaL_error(L, text);
    return 0;
  }
  return internal_to_table(L, &address, length);
}

// open a connection
int internal_connect(lua_State *L) {
  struct internal_addr addr_t;
  memset(&addr_t, 0, sizeof(addr_t));
  int result = internal_to_addr(L, &addr_t);
  if (result == -1) {
    return 0;
  }

  errno = 0;
  result = connect(addr_t.socket, &addr_t.address, sizeof(addr_t.address));
  if (result == -1) {
    char text[1024];
    sprintf(text, "error code: %d, error message: %s\r\n", errno, strerror(errno));
    luaL_error(L, text);
  }
  return 0;
}

// get peer name
int internal_get_peer_name(lua_State *L) {
  int socket = lua_tointeger(L, 1);
  struct sockaddr address;
  memset(&address, 0, sizeof(address));
  socklen_t length;

  errno = 0;
  int result = getpeername(socket, &address, &length);
  if (result == -1) {
    char text[1024];
    sprintf(text, "error code: %d, error message: %s\r\n", errno, strerror(errno));
    luaL_error(L, text);
    return 0;
  }
  return internal_to_table(L, &address, length);
}

// send data
int internal_send(lua_State *L) {
  return 0;
}

// receive data
int internal_recv(lua_State *L) {
  return 0;
}

// send to
int internal_send_to(lua_State *L) {
  return 0;
}

// receive from
int internal_recv_from(lua_State *L) {
  return 0;
}

// send message
int internal_send_msg(lua_State *L) {
  return 0;
}

// receive message
int internal_recv_msg(lua_State *L) {
  return 0;
}

// get socket option
int internal_get_sock_opt(lua_State *L) {
  return 0;
}

// set socket option
int internal_set_sock_opt(lua_State *L) {
  return 0;
}

// listen to a socket
int internal_listen(lua_State *L) {
  return 0;
}

// accept from a socket
int internal_accept(lua_State *L) {
  return 0;
}

// shutdown a socket
int internal_shutdown(lua_State *L) {
  return 0;
}

static const luaL_Reg register_function[] = {
  {"socket", internal_socket},
  {"socketpair", internal_socketpair},
  {"bind", internal_bind},
  {"connect", internal_connect},
  {"getpeername", internal_get_peer_name},
  {"send", internal_send},
  {"recv", internal_recv},
  {"sendto", internal_send_to},
  {"recvfrom", internal_recv_from},
  {"sendmsg", internal_send_msg},
  {"recvmsg", internal_recv_msg},
  {"getsockopt", internal_get_sock_opt},
  {"setsockopt", internal_set_sock_opt},
  {"listen", internal_listen},
  {"accept", internal_accept},
  {"shutdown", internal_shutdown},
  {NULL, NULL}
};

int luaopen_aul_socket_internal(lua_State *L) {
  luaL_newlib(L, register_function);
  return 1;
}
