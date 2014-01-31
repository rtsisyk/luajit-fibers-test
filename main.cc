#include <stdio.h>
#include <signal.h>
#include <sys/time.h>

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "lj_dispatch.h"
}

#include "tarantool/coro.h"

/* Lua C/API libraries */
#include "tarantool/lua/msgpack.h"
#include "box.h"

typedef void (*coro_fun_t)(void *data);

static void body1(void *);
static void body2(void *);

static coro_fun_t coro_fun[] = { body1, body2 };
static const int CORO_COUNT = sizeof(coro_fun) / sizeof(*coro_fun);
static struct tarantool_coro coro[CORO_COUNT];
static struct tarantool_coro sched;
static struct tarantool_coro *self = &sched;
static lua_State *L = NULL;

void
save_state(struct tarantool_coro *coro)
{
    (void) coro;
}

void
restore_state(struct tarantool_coro *coro)
{
    (void) coro;
}

void
transfer(struct tarantool_coro *callee)
{
	struct tarantool_coro *prev = self;
	save_state(self);
	self = callee;
	printf("#%d -> #%d\n", prev->id, self->id);

	restore_state(self);

	coro_transfer(&prev->ctx, &callee->ctx);
}

double
now()
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return tv.tv_sec + tv.tv_usec * 1e-6;
}


int
mktuple(struct lua_State *L, int i)
{
	lua_createtable(L, 2, 0);
	lua_pushinteger(L, i);
	lua_rawseti(L, -2, 1);
	lua_pushinteger(L, 2 * i);
	lua_rawseti(L, -2, 2);
	return 1;
}

static void
body1(void *data)
{
	(void) data;
	printf("Coro #1\n");

	try {
		lua_getglobal(L, "dofile");
		lua_pushstring(L, "init.lua");
		lua_call(L, lua_gettop(L) - 1, LUA_MULTRET);

	} catch (...) {
		const char *err = lua_tostring(L, 1);
		fprintf(stderr, "Lua error: %s\n", err);
		lua_settop(L, 0);
		return;
	}

	lua_getglobal(L, "COUNT");
	int COUNT = lua_tointeger(L, -1);
	lua_pop(L, 1);

	for (int f = 0 ; f < 0; f++) {
		if (f == 0) {
			printf("Benchmark\tFFI from lua_call\t%d\n", COUNT);
			lua_getglobal(L, "box");
		} else {
			printf("Benchmark\tAPI from lua_call\t%d\n", COUNT);
			lua_getglobal(L, "cbox");
		}

		double start = now();
		for (int i = 0; i < COUNT; i++) {
			lua_getfield(L, -1, "replace");
			mktuple(L, i);
			lua_call(L, 1, 1);
			lua_pop(L, 1); /* tuple */
		}

		double stop = now();
		printf("lua_call: %02f ops/s\n", COUNT / (stop - start));
		fflush(NULL);

		lua_pop(L, 1); /* box */
	}

	transfer(&sched);
}

static void
body2(void *data)
{
	(void) data;
	while (true) {
		printf("Coro #2\n");
		transfer(&coro[0]);
	}
}

#include "msgpuck/msgpuck.h"

int
main()
{
	L = luaL_newstate();
	if (L == NULL) {
		fprintf(stderr, "Lua failed!\n");
		return -1;
	}

	luaL_openlibs(L);
	luaopen_msgpack(L);
	lua_pop(L, 1);
	luaopen_box(L);
	lua_pop(L, 1);
	printf("lua_State (main): %p\n", L);

	save_state(self);
	for (int i = 0; i < CORO_COUNT; i++) {
		tarantool_coro_create(&coro[i], coro_fun[i], NULL);
		coro[i].id = i + 1;
		coro[i].thread_L = lua_newthread(L);
		coro[i].thread_ref = luaL_ref(L, LUA_REGISTRYINDEX);
		save_state(&coro[i]);
	}

	transfer(&coro[0]);

	for (int i = 0; i < CORO_COUNT; i++) {
		tarantool_coro_destroy(&coro[i]);
	}

	lua_close(L);

	return 0;
}
