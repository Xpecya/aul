#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

// get lua_State
int unsafe_get_state(lua_State *L);

// lua_arith is not in this plan
// you can simply use the operator instead
// int unsafe_arith(lua_State *L);

// lua_atpanic is not in this plan
// you can simple use xpcall in lua
// int unsafe_at_panic(lua_State *L);

// lua_call is not in this plan
// you can simply call the callable value
// int unsafe_lua_call(lua_State *L);

// check if the stack is available for the coming n extra elements
int unsafe_check_stack(lua_State *L);

// lua_close and lua_closeslot is not in this plan
// you don't really need to manually close everything in lua
// int unsafe_close(lua_State *L);
// int unsafe_close_slot(lua_State *L);

// lua_compare is not in this plan
// simply compare the value instead
// int unsafe_lua_compare(lua_State *L);

// lua_concat is not in this plan
// simply concat by .. instead
// int unsafe_lua_concat(lua_State *L);

// lua_copy is not in this plan
// it's a powerful function but no effect when used in lua
// int unsafe_copy(lua_State *L);

// create a new table with given size
int unsafe_create_table(lua_State *L);

// lua_dump is not in this plan
// there's no good path to send a lua_Writer function
// int unsafe_dump(lua_State *L);

// lua_error is not in this plan
// use error() function in lua instead
// int unsafe_error(lua_State *L);

// lua_gc is not in this plan
// use collectgarbage function instead
// int unsafe_gc(lua_State *L);

// lua_getallocf is not in this plan
// int unsafe_getallocf(lua_State *L);

// lua_getfield is not in this plan
// simply get the field instead
// int unsafe_get_field(lua_State *L);

// get extra space of this state
int unsafe_get_extra_space(lua_State *L);

// lua_getglobal is not in this plan
// global variable is easy to access in lua
// int unsafe_get_global(lua_State *L);

// lua_geti is not in this plan
// simply get it instead
// int unsafe_get_i(lua_State *L);

// create a new state
int unsafe_create_new_state(lua_State *L);

// do file with the given state
int unsafe_do_file(lua_State *L);

// open api
int luaopen_aul_unsafe_unsafe_internal(lua_State *L);
