#include <stdlib.h>
#include <string.h>
#include "lua/lauxlib.h"
#include "lua/lualib.h"

static int lua_writer(lua_State *L, const void *bytes, size_t size, void *vector)
{
    luaL_addlstring((luaL_Buffer *)vector, bytes, size);
    return 0;
}

void hex(char *hex, uint8_t *bytes, int size)
{
	int pointer = 0;
	char hex_char[16];
	for (int i = 0; i < size; ++i)
	{
		sprintf(hex_char, "%02x", (int)bytes[i]);
		memcpy(&hex[pointer], hex_char, strlen(hex_char));
		pointer += strlen(hex_char);
	}
}

int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        printf("no import lua entry file\n");
        return -1;
    }

    lua_State *L = luaL_newstate(0, 0);
    luaL_openlibs(L);
    luaL_loadfile(L, argv[1]);
    luaL_checktype(L, -1, LUA_TFUNCTION);

    luaL_Buffer vector;
    luaL_buffinit(luaL_newstate(0, 0), &vector);
    if (lua_dump(L, lua_writer, &vector, 1))
    {
        printf("lua_dump error\n");
    }

	// create luacode dep-cell
    FILE *f1 = fopen("luacode", "w+");
    fwrite(vector.b, sizeof(unsigned char), vector.n, f1);
    fclose(f1);

	// dump into luacode.c
    luaL_Buffer file;
    luaL_buffinit(luaL_newstate(0, 0), &file);
    char buffer[512];
    sprintf(buffer, "const unsigned int _GAME_CHUNK_SIZE = %lu;\nconst unsigned char _GAME_CHUNK[] = {", vector.n);
    luaL_addstring(&file, buffer);
    for (int i = 0; i < vector.n - 1; ++i)
    {
        sprintf(buffer, "%u, ", (unsigned char)vector.b[i]);
        luaL_addstring(&file, buffer);
    }
    if (vector.n > 0)
    {
        sprintf(buffer, "%u", (unsigned char)vector.b[vector.n - 1]);
        luaL_addstring(&file, buffer);
    }
    luaL_addstring(&file, "};");

    FILE *f2 = fopen(argv[2], "w+");
    fwrite(file.b, sizeof(unsigned char), file.n, f2);
    fclose(f2);

    return 0;
}
