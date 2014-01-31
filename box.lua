-- box.lua

local ffi = require('ffi')
local builtin = ffi.C
local msgpack = require('msgpack')

ffi.cdef([[
void
dump(char *pos, char *end);
size_t
echo(const char *pos, size_t size);

enum { TUPLE_FORMAT_INDEXED_COUNT = 2 };

struct tuple {
    uint32_t bsize;
    uint32_t offsets[TUPLE_FORMAT_INDEXED_COUNT];
    char data[0];
};

const char *exception;
struct tuple *
replace(const char *pos, const char *end);

void
tuple_ref(struct tuple *tuple, int ref);
]]);

--------------------------------------------------------------------------------
--- Buffer
--------------------------------------------------------------------------------
local DEFAULT_CAPACITY = 4096;

encoder = {}
encoder.s = ffi.new("char[?]", DEFAULT_CAPACITY)
encoder.e = encoder.s + DEFAULT_CAPACITY
encoder.p = encoder.s
encoder.reserve = function(enc, needed)
    if enc.p + needed <= enc.e then
        return
    end

    local size = enc.p - enc.s
    local capacity = enc.e - enc.s
    while capacity - size < needed do
        capacity = 2 * capacity
    end
    print("realloc ", capacity)

    local s = ffi.new("char[?]", capacity)
    ffi.copy(s, enc.s, size)
    enc.s = s
    enc.p = s + capacity
    enc.p = s + size
end
encoder.reset = function(enc)
    enc.p = enc.s
end

--------------------------------------------------------------------------------
--- FFI MsgPack Test
--------------------------------------------------------------------------------

if TEST then
    msgpack.encode(encoder, {1, 2, 3, "one", "two", "three", true, false,
        12.112311, -21312.0, { test = 10, tost = 15}, 123ULL, -123LL})

    builtin.dump(encoder.s, encoder.p)
    local datap = ffi.new('const char *[1]')
    datap[0] = encoder.s
    local t = msgpack.decode_unchecked(datap)

    for i=1,#t,1 do
        print('t['..i..']', t[i])
    end
    encoder:reset()
end

--------------------------------------------------------------------------------
--- Box
--------------------------------------------------------------------------------

local bufp = ffi.new('const char *[1]');
local function tuple_len(tuple)
    bufp[0] = tuple.data;
    return tonumber(builtin.mp_decode_array(bufp));
end

local function tuple_index(tuple, key)
    if type(key) ~= "number" then
        return nil
    end

    local m, e = math.modf(key)
    if m < 1 or e ~= 0 then
        return nil
    end

    if m < 1 or m > builtin.TUPLE_FORMAT_INDEXED_COUNT then
        error("Not implemented - non-indexed field");
    end

    bufp[0] = tuple.data + tuple.offsets[m - 1]
    return msgpack.decode_unchecked(bufp)
end

local tuple_t = ffi.typeof("struct tuple")
ffi.metatype(tuple_t, {
    __index = {
        field = tuple_index;
    };
    __len = tuple_len;
    __gc = function(tuple)
        tuple_ref(tuple, -1)
    end
})

local function builtin_replace(s, p)
    return builtin.replace(s, p)
end

local function builtin_replace_nojit(s, p)
    return builtin.replace(s, p)
end
require('jit').off(builtin_replace_nojit)

local function replace(tuple)
    encoder:reset()
    msgpack.encode_tuple(encoder, tuple)
    local cdata = builtin_replace(encoder.s, encoder.p)
    encoder:reset()
    if cdata == nil then
        error(ffi.string(builtin.exception))
    end
    return cdata
end

local function replace_nojit(tuple)
    encoder:reset()
    msgpack.encode_tuple(encoder, tuple)
    local cdata = builtin_replace_nojit(encoder.s, encoder.p)
    encoder:reset()
    if cdata == nil then
        error(ffi.string(builtin.exception))
    end
    return cdata
end

local box = {
    replace = replace;
    replace_nojit = replace_nojit;
}

return box
