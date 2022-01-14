#include "unsafe.h"

int unsafe_get_state(lua_State *L) {
  lua_pushlightuserdata(L, L);
  return 1;
}

int unsafe_check_stack(lua_State *L) {
  lua_Integer input = lua_tointeger(L, 1);
  int check_result = lua_checkstack(L, (int) input);
  lua_pushboolean(L, check_result);
  return 1;
}

int unsafe_create_table(lua_State *L) {
  lua_Integer narr = lua_tointeger(L, 1);
  lua_Integer nrec = lua_tointeger(L, 2);
  lua_createtable(L, narr, nrec);
  return 1;
}

int unsafe_get_extra_space(lua_State *L) {
  void *extra_space = lua_getextraspace(L);
  lua_pushlightuserdata(L, extra_space);
  return 1;
}

int unsafe_create_new_state(lua_State *L) {
  int open = lua_toboolean(L, 1);
  lua_State *new_state = luaL_newstate();
  if (open) {
    luaL_openlibs(new_state);
  }
  lua_pushlightuserdata(L, new_state);
  return 1;
}

int unsafe_do_file(lua_State *L) {
  void *data = lua_touserdata(L, 1);
  const char *file_name = lua_tostring(L, 2);
  luaL_dofile((lua_State *)data, file_name);
  return 0;
}

static const luaL_Reg register_function[] = {
  {"unsafe_get_state", unsafe_get_state},
  {"unsafe_check_stack", unsafe_check_stack},
  {"unsafe_create_table", unsafe_create_table},
  {"unsafe_get_extra_space", unsafe_get_extra_space},
  {"unsafe_create_new_state", unsafe_create_new_state},
  {"unsafe_do_file", unsafe_do_file},
  {NULL, NULL}
};

int luaopen_aul_unsafe_internal(lua_State *L) {
  luaL_newlib(L, register_function);
  return 1;
}
