#include "internal.h"

extern errno;

int internal_fdopen(lua_State *L) {
  int fd = lua_tointeger(L, 1);
  const char *type = lua_tostring(L, 2);
  FILE *file = fdopen(fd, type);
  luaL_Stream *stream = newfile(L);
  stream -> f = file;
  return 1;
}

static const luaL_Reg register_function[] = {
  {"fdopen", internal_fdopen},
  {NULL, NULL}
};

int luaopen_aul_standard_internal(lua_State *L) {
    luaL_newlib(L, register_function);
    return 1;
}

