#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <stdio.h>
#include <errno.h>
#include <liolib.c>

// fd => FILE
int internal_fdopen(lua_State *L);

int luaopen_aul_standard_internal(lua_State *L);
