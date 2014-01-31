#include "box.h"

#include <stdio.h>
#include "third_party/msgpuck/msgpuck.h"
#include "tarantool/tbuf.h"
#include "tarantool/lua/msgpack.h"
#include "tarantool/lua/utils.h"

#include <assert.h>

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "lj_dispatch.h"
} /* extern "C" */

extern "C" {

/*******************************************************************************
 * FFI
 ******************************************************************************/

void
dump_r(const char **data)
{
	uint64_t u64;
	int64_t i64;
	double dval;
	uint32_t size;
	const char *str;

	switch (mp_typeof(**data)) {
	case MP_UINT:
		u64 = mp_decode_uint(data);
		fprintf(stdout, " %llu", (unsigned long long) u64);
		break;
	case MP_INT:
		i64 = mp_decode_int(data);
		fprintf(stdout, " %lld", (long long) i64);
		break;
	case MP_FLOAT:
		dval = mp_decode_float(data);
		fprintf(stdout, " %f", dval);
		break;
	case MP_DOUBLE:
		dval = mp_decode_double(data);
		fprintf(stdout, " %lf", dval);
		break;
	case MP_STR:
		str = mp_decode_str(data, &size);
		fprintf(stdout, " \"%.*s\"", size, str);
		break;
	case MP_BIN:
		str = mp_decode_bin(data, &size);
		fprintf(stdout, " \"%.*s\"", size, str);
		break;
	case MP_MAP:
		size = mp_decode_map(data);
		fprintf(stdout, "{");
		for (uint32_t i = 0; i < size; i++) {
			dump_r(data);
			fprintf(stdout, ":");
			dump_r(data);
			if (i + 1 < size )
				fprintf(stdout, ", ");
		}
		fprintf(stdout, "}");
		break;
	case MP_ARRAY:
		size = mp_decode_array(data);
		fprintf(stdout, "[");
		for (uint32_t i = 0; i < size; i++) {
			dump_r(data);
			if (i + 1< size)
				fprintf(stdout, ", ");
		}
		fprintf(stdout, "]");
		break;
	case MP_NIL:
		mp_decode_nil(data);
		fprintf(stdout, " null");
		break;
	case MP_BOOL:
		if (mp_decode_bool(data)) {
			fprintf(stdout, " true");
		} else {
			fprintf(stdout, " false");
		}
		break;
	default:
		assert(false);
	}
}

void
dump(char *pos, char *end)
{
	fprintf(stderr, "size: %zu\n", end - pos);
	const char *p = pos;
	fprintf(stdout, "pos, end %zu\n", end - pos);
	if (!mp_check(&p, end)) {
		fprintf(stderr, "invalid msgpack\n");
		return;
	}

	fprintf(stdout, "pos, end %zu\n", end - pos);

	for (p = pos; p < end; p++) {
		fprintf(stderr, "0x%02x ", (unsigned char) *p);
	}
	fprintf(stderr, "\n");
	fprintf(stdout, "pos, end %zu\n", end - pos);

	p = pos;
	dump_r(&p);
	fprintf(stdout, "\n");
}

size_t
echo(const char *pos, size_t size)
{
	(void) pos;
	(void) size;
	return size;
}


char *arena = NULL;
char *arena_pos = NULL;
char *arena_end = NULL;

enum { TUPLE_FORMAT_INDEXED_COUNT = 2 };
const char *exception;

struct tuple {
	uint32_t bsize;
	uint32_t offsets[TUPLE_FORMAT_INDEXED_COUNT];
	char data[0];
};

uint64_t seq = 0;

struct tuple *
replace(const char *pos, const char *end)
{
	exception = NULL;
	const char *p;

	uint32_t bsize = (uint32_t) (end - pos);
	if (bsize >= 1024 * 1024) {
		exception = "Tuple is too large\n";
		return NULL;
	}

	p = pos;
	if (!mp_check(&p, end)) {
		exception = "Invalid MsgPack\n";
		return NULL;
	}

	if (mp_typeof(*pos) != MP_ARRAY) {
		exception = "Tuple must be array\n";
		return NULL;
	}

	p = pos;
	uint32_t count = mp_decode_array(&p);
	if (count < TUPLE_FORMAT_INDEXED_COUNT) {
		exception = "Indexed fields must be filled in\n";
		return NULL;
	}

	struct tuple *tuple = (struct tuple *) arena_pos;
	arena_pos += sizeof(struct tuple *) + bsize;
	if (arena_pos >= arena_end) {
		exception = "Out of memory\n";
		return NULL;
	}

	tuple->bsize = bsize;

	for (uint32_t i = 0; i < TUPLE_FORMAT_INDEXED_COUNT; i++) {
		tuple->offsets[i] = (uint32_t) (p - pos);
		mp_next(&p);
	}

	memcpy(tuple->data, pos, bsize);
	++seq;
	return tuple;
}

void
tuple_ref(struct tuple *tuple, int ref)
{
	(void) tuple;
	(void) ref;
	// printf("tuple_ref (%p, %d)\n", tuple, ref);
}

} /* extern "C" */

/*******************************************************************************
 * Lua C/API
 ******************************************************************************/

static const char *tuplelib_name = "box.tuple";

static inline struct tuple *
lua_checktuple(struct lua_State *L, int narg)
{
	struct tuple *t = *(struct tuple **) luaL_checkudata(L, narg, tuplelib_name);
	// assert(t->refs);
	return t;
}

static int
lbox_tuple_gc(struct lua_State *L)
{
	struct tuple *tuple = lua_checktuple(L, 1);
	tuple_ref(tuple, -1);
	return 0;
}

static int
lbox_tuple_len(struct lua_State *L)
{
	struct tuple *tuple = lua_checktuple(L, 1);
	const char *data = tuple->data;
	lua_pushnumber(L, mp_decode_array(&data));
	return 1;
}

static void
lbox_pushtuple(struct lua_State *L, struct tuple *tuple)
{
	if (tuple) {
		struct tuple **ptr = (struct tuple **)
				lua_newuserdata(L, sizeof(*ptr));
		luaL_getmetatable(L, tuplelib_name);
		lua_setmetatable(L, -2);
		*ptr = tuple;
		tuple_ref(tuple, 1);
	} else {
		lua_pushnil(L);
	}
}

static int
lbox_tuple_index(struct lua_State *L)
{
	struct tuple *tuple = lua_checktuple(L, 1);
	/* For integer indexes, implement [] operator */
	if (lua_isnumber(L, 2)) {
		int i = luaL_checkint(L, 2);
		if (i < 1 || i > TUPLE_FORMAT_INDEXED_COUNT)
			return luaL_error(L, "Not implemented - non-indexed field");
		const char *field = tuple->data + tuple->offsets[i - 1];
		luamp_decode(L, &field);
		return 1;
	}

	/* If we got a string, try to find a method for it. */
	const char *sz = luaL_checkstring(L, 2);
	lua_getmetatable(L, 1);
	lua_getfield(L, -1, sz);
	return 1;
}

static const struct luaL_reg lbox_tuple_meta[] = {
	{"__gc", lbox_tuple_gc},
	{"__len", lbox_tuple_len},
	{"__index", lbox_tuple_index},
	{"field", lbox_tuple_index},
	{NULL, NULL}
};

static int
lbox_replace(struct lua_State *L)
{
	int index = lua_gettop(L);
	if (index != 1)
		luaL_error(L, "msgpack.encode: a Lua object expected");

	struct tbuf *buf = tbuf_new();
	luamp_encode(L, buf, 1);
	struct tuple *tuple = replace(buf->data, buf->data + buf->size);
	if (tuple == NULL) {
		return luaL_error(L, exception);
	}
	lbox_pushtuple(L, tuple);
	return 1;
}

static int
lbox_check_cdata(struct lua_State *L)
{
	int index = lua_gettop(L);
	if (index != 1)
		luaL_error(L, "msgpack.encode: a Lua object expected");

	uint32_t ctypeid = 0;

	void *val = luaL_checkcdata(L, 1, &ctypeid);
	printf("typeid: %p %u\n", *(void **) val, ctypeid);
	return 0;
}

static int
lbox_replace_cdata(struct lua_State *L)
{
	int index = lua_gettop(L);
	if (index != 1)
		luaL_error(L, "msgpack.encode: a Lua object expected");

	struct tbuf *buf = tbuf_new();
	luamp_encode(L, buf, 1);
	struct tuple *tuple = replace(buf->data, buf->data + buf->size);
	if (tuple == NULL) {
		return luaL_error(L, exception);
	}
	struct tuple **ptuple = (struct tuple **)
			luaL_pushcdata(L, 174, sizeof(struct tuple *));
	*ptuple = tuple;
	return 1;
}

static int
lbox_reset(struct lua_State *L)
{
	(void) L;
	arena_pos = arena;
	return 0;
}

LUALIB_API int
luaopen_box(lua_State *L)
{
	size_t arena_size = 1024ULL * 1024 * 1024 * 4;
	arena = (char *) malloc(arena_size);
	assert(arena != NULL);
	arena_pos = arena;
	arena_end = arena + arena_size;

	luaL_register_type(L, tuplelib_name, lbox_tuple_meta);

	const luaL_reg boxlib[] = {
		{ "reset", lbox_reset },
		{ "check_cdata", lbox_check_cdata },
		{ "replace", lbox_replace },
		{ "replace_cdata", lbox_replace_cdata },
		{ NULL, NULL}

	};
	luaL_openlib(L, "cbox", boxlib, 0);
	return 1;
}
