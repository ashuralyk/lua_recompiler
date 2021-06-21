#include <stdlib.h>
#include <string.h>
#include "lua/lauxlib.h"
#include "lua/lualib.h"

static int error_handler(lua_State *L)
{
    const char *error = lua_tostring(L, -1);
    printf("error = %s\n", error);
    return 0;
}

#include "luacode.c"
int main()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushcfunction(L, error_handler);
    int herr = lua_gettop(L);

    if (luaL_loadbuffer(L, _GAME_CHUNK, _GAME_CHUNK_SIZE, "test")
        || lua_pcall(L, 0, 0, herr))
    {
        printf("bad lua code\n");
    }

	lua_getglobal(L, "spell_card");
	lua_pushstring(L, "user1");
	lua_pushstring(L, "user2");
	lua_pushstring(L, "97bff01bcad316a4b534ef221bd66da97018df90");
	lua_pcall(L, 3, 0, herr);
}