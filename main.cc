#include <stdio.h>
#include <signal.h>

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "lj_dispatch.h"
}

#include "tarantool/coro.h"

/* Lua C/API libraries */

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
transfer(struct tarantool_coro *callee)
{
	struct tarantool_coro *prev = self;

	self = callee;
	printf("#%d -> #%d\n", prev->id, self->id);

	coro_transfer(&prev->ctx, &callee->ctx);
}

static void
body1(void *data)
{
	(void) data;
	printf("Coro #1\n");

	transfer(&coro[0]);

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

int
main()
{
	L = luaL_newstate();
	if (L == NULL) {
		fprintf(stderr, "Lua failed!\n");
		return -1;
	}

	luaL_openlibs(L);

	for (int i = 0; i < CORO_COUNT; i++) {
		tarantool_coro_create(&coro[i], coro_fun[i], NULL);
		coro[i].id = i + 1;
		coro[i].thread_L = lua_newthread(L);
		coro[i].thread_ref = luaL_ref(L, LUA_REGISTRYINDEX);
	}

	transfer(&coro[0]);

	for (int i = 0; i < CORO_COUNT; i++) {
		tarantool_coro_destroy(&coro[i]);
	}

	lua_close(L);

	return 0;
}
