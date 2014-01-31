
local ffi = require('ffi')
ffi.cdef([[
enum mp_type {
	MP_NIL = 0,
	MP_UINT,
	MP_INT,
	MP_STR,
	MP_BIN,
	MP_ARRAY,
	MP_MAP,
	MP_BOOL,
	MP_FLOAT,
	MP_DOUBLE,
	MP_EXT
};
extern const int mp_type_hint[];

char *
mp_encode_array(char *data, uint32_t size);
char *
mp_encode_map(char *data, uint32_t size);
char *
mp_encode_uint(char *data, uint64_t num);
char *
mp_encode_int(char *data, int64_t num);
char *
mp_encode_double(char *data, double num);
char *
mp_encode_str(char *data, const char *str, uint32_t len);
char *
mp_encode_strl(char *data, uint32_t len);
char *
mp_encode_bool(char *data, bool val);
char *
mp_encode_nil(char *data);

uint32_t
mp_decode_array(const char **data);
uint32_t
mp_decode_map(const char **data);
uint64_t
mp_decode_uint(const char **data);
uint64_t
mp_decode_int(const char **data);
float
mp_decode_float(const char **data);
double
mp_decode_double(const char **data);
uint32_t
mp_decode_strl(const char **data);
bool
mp_decode_bool(const char **data);
void
mp_decode_nil(const char **data);
]])

local builtin = ffi.C

local type_hint = {
    --[[{{{ MP_UINT (fixed) ]]
    --[[0x00 ]] builtin.MP_UINT,
    --[[0x01 ]] builtin.MP_UINT,
    --[[0x02 ]] builtin.MP_UINT,
    --[[0x03 ]] builtin.MP_UINT,
    --[[0x04 ]] builtin.MP_UINT,
    --[[0x05 ]] builtin.MP_UINT,
    --[[0x06 ]] builtin.MP_UINT,
    --[[0x07 ]] builtin.MP_UINT,
    --[[0x08 ]] builtin.MP_UINT,
    --[[0x09 ]] builtin.MP_UINT,
    --[[0x0a ]] builtin.MP_UINT,
    --[[0x0b ]] builtin.MP_UINT,
    --[[0x0c ]] builtin.MP_UINT,
    --[[0x0d ]] builtin.MP_UINT,
    --[[0x0e ]] builtin.MP_UINT,
    --[[0x0f ]] builtin.MP_UINT,
    --[[0x10 ]] builtin.MP_UINT,
    --[[0x11 ]] builtin.MP_UINT,
    --[[0x12 ]] builtin.MP_UINT,
    --[[0x13 ]] builtin.MP_UINT,
    --[[0x14 ]] builtin.MP_UINT,
    --[[0x15 ]] builtin.MP_UINT,
    --[[0x16 ]] builtin.MP_UINT,
    --[[0x17 ]] builtin.MP_UINT,
    --[[0x18 ]] builtin.MP_UINT,
    --[[0x19 ]] builtin.MP_UINT,
    --[[0x1a ]] builtin.MP_UINT,
    --[[0x1b ]] builtin.MP_UINT,
    --[[0x1c ]] builtin.MP_UINT,
    --[[0x1d ]] builtin.MP_UINT,
    --[[0x1e ]] builtin.MP_UINT,
    --[[0x1f ]] builtin.MP_UINT,
    --[[0x20 ]] builtin.MP_UINT,
    --[[0x21 ]] builtin.MP_UINT,
    --[[0x22 ]] builtin.MP_UINT,
    --[[0x23 ]] builtin.MP_UINT,
    --[[0x24 ]] builtin.MP_UINT,
    --[[0x25 ]] builtin.MP_UINT,
    --[[0x26 ]] builtin.MP_UINT,
    --[[0x27 ]] builtin.MP_UINT,
    --[[0x28 ]] builtin.MP_UINT,
    --[[0x29 ]] builtin.MP_UINT,
    --[[0x2a ]] builtin.MP_UINT,
    --[[0x2b ]] builtin.MP_UINT,
    --[[0x2c ]] builtin.MP_UINT,
    --[[0x2d ]] builtin.MP_UINT,
    --[[0x2e ]] builtin.MP_UINT,
    --[[0x2f ]] builtin.MP_UINT,
    --[[0x30 ]] builtin.MP_UINT,
    --[[0x31 ]] builtin.MP_UINT,
    --[[0x32 ]] builtin.MP_UINT,
    --[[0x33 ]] builtin.MP_UINT,
    --[[0x34 ]] builtin.MP_UINT,
    --[[0x35 ]] builtin.MP_UINT,
    --[[0x36 ]] builtin.MP_UINT,
    --[[0x37 ]] builtin.MP_UINT,
    --[[0x38 ]] builtin.MP_UINT,
    --[[0x39 ]] builtin.MP_UINT,
    --[[0x3a ]] builtin.MP_UINT,
    --[[0x3b ]] builtin.MP_UINT,
    --[[0x3c ]] builtin.MP_UINT,
    --[[0x3d ]] builtin.MP_UINT,
    --[[0x3e ]] builtin.MP_UINT,
    --[[0x3f ]] builtin.MP_UINT,
    --[[0x40 ]] builtin.MP_UINT,
    --[[0x41 ]] builtin.MP_UINT,
    --[[0x42 ]] builtin.MP_UINT,
    --[[0x43 ]] builtin.MP_UINT,
    --[[0x44 ]] builtin.MP_UINT,
    --[[0x45 ]] builtin.MP_UINT,
    --[[0x46 ]] builtin.MP_UINT,
    --[[0x47 ]] builtin.MP_UINT,
    --[[0x48 ]] builtin.MP_UINT,
    --[[0x49 ]] builtin.MP_UINT,
    --[[0x4a ]] builtin.MP_UINT,
    --[[0x4b ]] builtin.MP_UINT,
    --[[0x4c ]] builtin.MP_UINT,
    --[[0x4d ]] builtin.MP_UINT,
    --[[0x4e ]] builtin.MP_UINT,
    --[[0x4f ]] builtin.MP_UINT,
    --[[0x50 ]] builtin.MP_UINT,
    --[[0x51 ]] builtin.MP_UINT,
    --[[0x52 ]] builtin.MP_UINT,
    --[[0x53 ]] builtin.MP_UINT,
    --[[0x54 ]] builtin.MP_UINT,
    --[[0x55 ]] builtin.MP_UINT,
    --[[0x56 ]] builtin.MP_UINT,
    --[[0x57 ]] builtin.MP_UINT,
    --[[0x58 ]] builtin.MP_UINT,
    --[[0x59 ]] builtin.MP_UINT,
    --[[0x5a ]] builtin.MP_UINT,
    --[[0x5b ]] builtin.MP_UINT,
    --[[0x5c ]] builtin.MP_UINT,
    --[[0x5d ]] builtin.MP_UINT,
    --[[0x5e ]] builtin.MP_UINT,
    --[[0x5f ]] builtin.MP_UINT,
    --[[0x60 ]] builtin.MP_UINT,
    --[[0x61 ]] builtin.MP_UINT,
    --[[0x62 ]] builtin.MP_UINT,
    --[[0x63 ]] builtin.MP_UINT,
    --[[0x64 ]] builtin.MP_UINT,
    --[[0x65 ]] builtin.MP_UINT,
    --[[0x66 ]] builtin.MP_UINT,
    --[[0x67 ]] builtin.MP_UINT,
    --[[0x68 ]] builtin.MP_UINT,
    --[[0x69 ]] builtin.MP_UINT,
    --[[0x6a ]] builtin.MP_UINT,
    --[[0x6b ]] builtin.MP_UINT,
    --[[0x6c ]] builtin.MP_UINT,
    --[[0x6d ]] builtin.MP_UINT,
    --[[0x6e ]] builtin.MP_UINT,
    --[[0x6f ]] builtin.MP_UINT,
    --[[0x70 ]] builtin.MP_UINT,
    --[[0x71 ]] builtin.MP_UINT,
    --[[0x72 ]] builtin.MP_UINT,
    --[[0x73 ]] builtin.MP_UINT,
    --[[0x74 ]] builtin.MP_UINT,
    --[[0x75 ]] builtin.MP_UINT,
    --[[0x76 ]] builtin.MP_UINT,
    --[[0x77 ]] builtin.MP_UINT,
    --[[0x78 ]] builtin.MP_UINT,
    --[[0x79 ]] builtin.MP_UINT,
    --[[0x7a ]] builtin.MP_UINT,
    --[[0x7b ]] builtin.MP_UINT,
    --[[0x7c ]] builtin.MP_UINT,
    --[[0x7d ]] builtin.MP_UINT,
    --[[0x7e ]] builtin.MP_UINT,
    --[[0x7f ]] builtin.MP_UINT,
    --[[}}} ]]

    --[[{{{ MP_MAP (fixed) ]]
    --[[0x80 ]] builtin.MP_MAP,
    --[[0x81 ]] builtin.MP_MAP,
    --[[0x82 ]] builtin.MP_MAP,
    --[[0x83 ]] builtin.MP_MAP,
    --[[0x84 ]] builtin.MP_MAP,
    --[[0x85 ]] builtin.MP_MAP,
    --[[0x86 ]] builtin.MP_MAP,
    --[[0x87 ]] builtin.MP_MAP,
    --[[0x88 ]] builtin.MP_MAP,
    --[[0x89 ]] builtin.MP_MAP,
    --[[0x8a ]] builtin.MP_MAP,
    --[[0x8b ]] builtin.MP_MAP,
    --[[0x8c ]] builtin.MP_MAP,
    --[[0x8d ]] builtin.MP_MAP,
    --[[0x8e ]] builtin.MP_MAP,
    --[[0x8f ]] builtin.MP_MAP,
    --[[}}} ]]

    --[[{{{ MP_ARRAY (fixed) ]]
    --[[0x90 ]] builtin.MP_ARRAY,
    --[[0x91 ]] builtin.MP_ARRAY,
    --[[0x92 ]] builtin.MP_ARRAY,
    --[[0x93 ]] builtin.MP_ARRAY,
    --[[0x94 ]] builtin.MP_ARRAY,
    --[[0x95 ]] builtin.MP_ARRAY,
    --[[0x96 ]] builtin.MP_ARRAY,
    --[[0x97 ]] builtin.MP_ARRAY,
    --[[0x98 ]] builtin.MP_ARRAY,
    --[[0x99 ]] builtin.MP_ARRAY,
    --[[0x9a ]] builtin.MP_ARRAY,
    --[[0x9b ]] builtin.MP_ARRAY,
    --[[0x9c ]] builtin.MP_ARRAY,
    --[[0x9d ]] builtin.MP_ARRAY,
    --[[0x9e ]] builtin.MP_ARRAY,
    --[[0x9f ]] builtin.MP_ARRAY,
    --[[}}} ]]

    --[[{{{ MP_STR (fixed) ]]
    --[[0xa0 ]] builtin.MP_STR,
    --[[0xa1 ]] builtin.MP_STR,
    --[[0xa2 ]] builtin.MP_STR,
    --[[0xa3 ]] builtin.MP_STR,
    --[[0xa4 ]] builtin.MP_STR,
    --[[0xa5 ]] builtin.MP_STR,
    --[[0xa6 ]] builtin.MP_STR,
    --[[0xa7 ]] builtin.MP_STR,
    --[[0xa8 ]] builtin.MP_STR,
    --[[0xa9 ]] builtin.MP_STR,
    --[[0xaa ]] builtin.MP_STR,
    --[[0xab ]] builtin.MP_STR,
    --[[0xac ]] builtin.MP_STR,
    --[[0xad ]] builtin.MP_STR,
    --[[0xae ]] builtin.MP_STR,
    --[[0xaf ]] builtin.MP_STR,
    --[[0xb0 ]] builtin.MP_STR,
    --[[0xb1 ]] builtin.MP_STR,
    --[[0xb2 ]] builtin.MP_STR,
    --[[0xb3 ]] builtin.MP_STR,
    --[[0xb4 ]] builtin.MP_STR,
    --[[0xb5 ]] builtin.MP_STR,
    --[[0xb6 ]] builtin.MP_STR,
    --[[0xb7 ]] builtin.MP_STR,
    --[[0xb8 ]] builtin.MP_STR,
    --[[0xb9 ]] builtin.MP_STR,
    --[[0xba ]] builtin.MP_STR,
    --[[0xbb ]] builtin.MP_STR,
    --[[0xbc ]] builtin.MP_STR,
    --[[0xbd ]] builtin.MP_STR,
    --[[0xbe ]] builtin.MP_STR,
    --[[0xbf ]] builtin.MP_STR,
    --[[}}} ]]

    --[[{{{ MP_NIL, MP_BOOL ]]
    --[[0xc0 ]] builtin.MP_NIL,
    --[[0xc1 ]] builtin.MP_EXT, --[[never used ]]
    --[[0xc2 ]] builtin.MP_BOOL,
    --[[0xc3 ]] builtin.MP_BOOL,
    --[[}}} ]]

    --[[{{{ MP_BIN ]]
    --[[0xc4 ]] builtin.MP_BIN,   --[[MP_BIN(8)  ]]
    --[[0xc5 ]] builtin.MP_BIN,   --[[MP_BIN(16) ]]
    --[[0xc6 ]] builtin.MP_BIN,   --[[MP_BIN(32) ]]
    --[[}}} ]]

    --[[{{{ MP_EXT ]]
    --[[0xc7 ]] builtin.MP_EXT,
    --[[0xc8 ]] builtin.MP_EXT,
    --[[0xc9 ]] builtin.MP_EXT,
    --[[}}} ]]

    --[[{{{ MP_FLOAT, MP_DOUBLE ]]
    --[[0xca ]] builtin.MP_FLOAT,
    --[[0xcb ]] builtin.MP_DOUBLE,
    --[[}}} ]]

    --[[{{{ MP_UINT ]]
    --[[0xcc ]] builtin.MP_UINT,
    --[[0xcd ]] builtin.MP_UINT,
    --[[0xce ]] builtin.MP_UINT,
    --[[0xcf ]] builtin.MP_UINT,
    --[[}}} ]]

    --[[{{{ MP_INT ]]
    --[[0xd0 ]] builtin.MP_INT,   --[[MP_INT (8)  ]]
    --[[0xd1 ]] builtin.MP_INT,   --[[MP_INT (16) ]]
    --[[0xd2 ]] builtin.MP_INT,   --[[MP_INT (32) ]]
    --[[0xd3 ]] builtin.MP_INT,   --[[MP_INT (64) ]]
    --[[}}} ]]

    --[[{{{ MP_EXT ]]
    --[[0xd4 ]] builtin.MP_EXT,   --[[MP_INT (8)    ]]
    --[[0xd5 ]] builtin.MP_EXT,   --[[MP_INT (16)   ]]
    --[[0xd6 ]] builtin.MP_EXT,   --[[MP_INT (32)   ]]
    --[[0xd7 ]] builtin.MP_EXT,   --[[MP_INT (64)   ]]
    --[[0xd8 ]] builtin.MP_EXT,   --[[MP_INT (127)  ]]
    --[[}}} ]]

    --[[{{{ MP_STR ]]
    --[[0xd9 ]] builtin.MP_STR,   --[[MP_STR(8)  ]]
    --[[0xda ]] builtin.MP_STR,   --[[MP_STR(16) ]]
    --[[0xdb ]] builtin.MP_STR,   --[[MP_STR(32) ]]
    --[[}}} ]]

    --[[{{{ MP_ARRAY ]]
    --[[0xdc ]] builtin.MP_ARRAY, --[[MP_ARRAY(16)  ]]
    --[[0xdd ]] builtin.MP_ARRAY, --[[MP_ARRAY(32)  ]]
    --[[}}} ]]

    --[[{{{ MP_MAP ]]
    --[[0xde ]] builtin.MP_MAP,   --[[MP_MAP (16) ]]
    --[[0xdf ]] builtin.MP_MAP,   --[[MP_MAP (32) ]]
    --[[}}} ]]

    --[[{{{ MP_INT ]]
    --[[0xe0 ]] builtin.MP_INT,
    --[[0xe1 ]] builtin.MP_INT,
    --[[0xe2 ]] builtin.MP_INT,
    --[[0xe3 ]] builtin.MP_INT,
    --[[0xe4 ]] builtin.MP_INT,
    --[[0xe5 ]] builtin.MP_INT,
    --[[0xe6 ]] builtin.MP_INT,
    --[[0xe7 ]] builtin.MP_INT,
    --[[0xe8 ]] builtin.MP_INT,
    --[[0xe9 ]] builtin.MP_INT,
    --[[0xea ]] builtin.MP_INT,
    --[[0xeb ]] builtin.MP_INT,
    --[[0xec ]] builtin.MP_INT,
    --[[0xed ]] builtin.MP_INT,
    --[[0xee ]] builtin.MP_INT,
    --[[0xef ]] builtin.MP_INT,
    --[[0xf0 ]] builtin.MP_INT,
    --[[0xf1 ]] builtin.MP_INT,
    --[[0xf2 ]] builtin.MP_INT,
    --[[0xf3 ]] builtin.MP_INT,
    --[[0xf4 ]] builtin.MP_INT,
    --[[0xf5 ]] builtin.MP_INT,
    --[[0xf6 ]] builtin.MP_INT,
    --[[0xf7 ]] builtin.MP_INT,
    --[[0xf8 ]] builtin.MP_INT,
    --[[0xf9 ]] builtin.MP_INT,
    --[[0xfa ]] builtin.MP_INT,
    --[[0xfb ]] builtin.MP_INT,
    --[[0xfc ]] builtin.MP_INT,
    --[[0xfd ]] builtin.MP_INT,
    --[[0xfe ]] builtin.MP_INT,
    --[[0xff ]] builtin.MP_INT
    --[[}}} ]]
};

print('hints_size', #type_hint)

UINT8_MAX = 255
UINT16_MAX = 65535
UINT32_MAX = 4294967295

local function bswap_u16(num)
    return bit.rshift(bit.bswap(num), 16)
end

local function bswap_u32(num)
    return bit.bswap(num)
end

local function bswap_u64(num)
    return bit.bswap(num)
end

local function encode_uint(data, num)
    if num <= 0x7f then
        data[0] = num
        return data + 1
    elseif num <= UINT8_MAX then
        data[0] = 0xcc;
        ffi.cast('uint8_t *', data + 1)[0] = num;
        return data + 2
    elseif num <= UINT16_MAX then
        data[0] = 0xcd;
        ffi.cast('uint16_t *', data + 1)[0] = bswap_u16(num);
        return data + 3
    elseif num <= UINT32_MAX then
        data[0] = 0xce
        ffi.cast('uint32_t *', data + 1)[0] = bswap_u32(num);
        return data + 5
    else
        data[0] = 0xcf;
        ffi.cast('uint64_t *', data + 1)[0] = bswap_u64(num);
        return data + 9
    end
end

local MSGPACK_INLINE = false

local function encode2(enc, obj)
    if type(obj) == "number" then
        enc:reserve(9)
        if MSGPACK_INLINE then
        enc.p = encode_uint(enc.p, obj)
        else
        local m, e = math.modf(obj)
        if e == 0 then
            if m >= 0 then
                enc.p = builtin.mp_encode_uint(enc.p, ffi.cast('uint64_t', obj))
            else
                enc.p = builtin.mp_encode_int(enc.p, ffi.cast('int64_t', obj))
            end
        else
            enc.p = builtin.mp_encode_double(enc.p, obj)
        end
        end
    elseif type(obj) == "string" then
        enc:reserve(5 + #obj)
        enc.p = builtin.mp_encode_str(enc.p, obj, #obj)
    elseif type(obj) == "table" then
        if #obj > 0 then
            enc.p = builtin.mp_encode_array(enc.p, #obj)
            local _it, val
            for i=1,#obj,1 do
                encode2(enc, obj[i])
            end
        else
            local size = 0
            local key, val
            for key, val in pairs(obj) do
                size = size + 1
            end
            enc.p = builtin.mp_encode_map(enc.p, size)
            for key, val in pairs(obj) do
                encode2(enc, key)
                encode2(enc, val)
            end
        end
    elseif obj == nil then
        enc:reserve(1)
        enc.p = builtin.mp_encode_nil(enc.p)
    elseif type(obj) == "boolean" then
        enc:reserve(1)
        enc.p = builtin.mp_encode_bool(enc.p, obj)
    elseif type(obj) == "cdata" then
        if not ffi.cast('uint64_t', obj) then
            error('unsupported FFI type: '..ffi.typeof(obj))
        end
        enc:reserve(9)
        if obj >= 0 then
            enc.p = encode_uint(enc.p, obj)
        else
            enc.p = builtin.mp_encode_int(enc.p, obj)
        end
    else
        error("Unsupported Lua type: "..type(obj));
    end
end

local function encode_tuple(enc, obj)
    local size = #obj
    enc.p = builtin.mp_encode_array(enc.p, size)
    local i
    for i=1,size,1 do
        encode2(enc, obj[i])
    end
end

local function encode(enc, obj)
    local i = 1
    local toencode = { obj }
    while i <= #toencode do
        local obj = toencode[i]
        local objtype = type(obj)
        if objtype == "number" then
            enc:reserve(9)
            local m, e = math.modf(obj)
            if e == 0 then
                if m >= 0 then
                    enc.p = builtin.mp_encode_uint(enc.p, ffi.cast('uint64_t', obj))
                else
                    enc.p = builtin.mp_encode_int(enc.p, ffi.cast('int64_t', obj))
                end
            else
                enc.p = builtin.mp_encode_double(enc.p, obj)
            end
        elseif objtype == "string" then
            enc:reserve(5 + #obj)
            enc.p = builtin.mp_encode_str(enc.p, obj, #obj)
        elseif objtype == "table" then
            if #obj > 0 then
                enc.p = builtin.mp_encode_array(enc.p, #obj)
                local _it, val
                for _it, val in ipairs(obj) do
                    table.insert(toencode, val)
                end
            else
                local size = 0
                local key, val
                for key, val in pairs(obj) do
                    size = size + 1
                end
                enc.p = builtin.mp_encode_map(enc.p, size)
                for key, val in pairs(obj) do
                    table.insert(toencode, key)
                    table.insert(toencode, val)
                end
            end
        elseif obj == nil then
            enc:reserve(1)
            enc.p = builtin.mp_encode_nil(enc.p)
        elseif objtype == "boolean" then
            enc:reserve(1)
            enc.p = builtin.mp_encode_bool(enc.p, obj)
        elseif objtype == "cdata" then
            if not ffi.cast('uint64_t', obj) then
                error('unsupported FFI type: '..ffi.typeof(obj))
            end
            enc:reserve(9)
            if obj >= 0 then
                enc.p = builtin.mp_encode_uint(enc.p, obj)
            else
                enc.p = builtin.mp_encode_int(enc.p, obj)
            end
        else
            error("Unsupported Lua type: "..type(obj));
        end
        i = i + 1
    end
    toencode = nil
end

local function cdatatonumber(cnum)
    local num = tonumber(cnum)
    if cnum == num then
        return num
    end
    return cnum
end


local unsigned_char_t = ffi.typeof('unsigned char');

local function decode_unchecked(data)
    local c = tonumber(ffi.cast(unsigned_char_t, data[0][0]));
    local type = type_hint[c + 1];
    if type == builtin.MP_UINT then
        return cdatatonumber(builtin.mp_decode_uint(data))
    elseif type == builtin.MP_INT then
        return cdatatonumber(builtin.mp_decode_int(data))
    elseif type == builtin.MP_FLOAT then
        return tonumber(builtin.mp_decode_float(data))
    elseif type == builtin.MP_DOUBLE then
        return tonumber(builtin.mp_decode_double(data))
    elseif type == builtin.MP_STR then
        local len = builtin.mp_decode_strl(data)
        local str = ffi.string(data[0], len)
        data[0] = data[0] + len
        return str
    elseif type == builtin.MP_ARRAY then
        local size = builtin.mp_decode_array(data)
        local arr = { [size] = 0}
        for i=1,size,1 do
            arr[i] = decode_unchecked(data)
        end
        return arr
    elseif type == builtin.MP_MAP then
        local size = builtin.mp_decode_array(data)
        local map = {}
        for i=1,size,1 do
            local key = decode_unchecked(data)
            local value = decode_unchecked(data)
            map[key] = value
        end
        return map
    elseif type == builtin.MP_BOOL then
        return builtin.mp_decode_bool(data)
    elseif type == builtin.MP_NIL then
        builtin.mp_decode_nil(data)
        return ffi.cast('void *', 0)
    else
        error("Unsupported type: "..tostring(type))
    end
end

msgpack = {
    encode = encode2,
    encode_tuple = encode_tuple,
    decode_unchecked = decode_unchecked
}

return msgpack
