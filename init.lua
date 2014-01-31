box = require('box')

local ffi = require('ffi')
local builtin = ffi.C

package.path = "third_party/luajit-2.1/src/?.lua;"..package.path
require("jit.v").start("jit.txt")

ffi.cdef[[
    typedef long time_t;
    typedef struct timeval {
    time_t tv_sec;
    time_t tv_usec;
} timeval;

int gettimeofday(struct timeval* t, void* tzp);
uint64_t seq;
]]

local timeval = ffi.new("timeval")
local function now()
    builtin.gettimeofday(timeval, nil)
    local sec = tonumber(timeval.tv_sec)
    local usec = tonumber(timeval.tv_usec)
    return sec + usec * 1e-6
end

--------------------------------------------------------------------------------
--- Benchmark
--------------------------------------------------------------------------------

local function mktuple1(i)
    return { i, 2 * i}
end

local function mktuple2(i)
    return { i, 2 * i, 3 * i, 4 * i}
end

local function mktuple3(i)
    return { i, 2 * i, 3 * i, 4 * i, 5 * i, 6 * i}
end

local function mktuple4(i)
    return { i, 2 * i, "abcdefgd", "abcdefgdabcdefgd"}
end

local function mktuple5(i)
    return { i, 2 * i, 3 * i, 4 * i, 5 * i, 6 * i, 7 * i, 8 * i, 9 * i, 10 * i}
end

local ops_base = nil
local function bench(fun, mktuple, n, name)
    collectgarbage("collect")
    cbox.reset()
    local start = now()
    local check = 0
    local i
    for i=0,n,1 do
        local tuple = mktuple(i)
        local tuple2 = fun(tuple)
        assert (tuple[1] == tuple2:field(1))
        check = check + tuple[1]
    end
    local stop = now()
    local ops = n / (stop - start)
    if ops_base == nil then
        ops_base = ops
    end
    print(string.format('%-25s %.f %.f %%', name, ops, ops / ops_base * 1e2))
    return ops
end

print('Version ', jit.version)

local k = 10000

print('Test Lua/C API')
local tuple = cbox.replace(mktuple1(k))
print('tuple', tuple)
print('#tuple', #tuple)
print('tuple[1]', tuple:field(1))
print('tuple[2]', tuple:field(2))

print("")

print('Test FFI API')
local tuple = box.replace(mktuple1(k))
print('tuple', tuple)
print('#tuple', #tuple)
print('tuple[1]', tuple:field(1))
print('tuple[2]', tuple:field(2))
cbox.check_cdata(tuple)
print("")

print('Test Lua/C API + cdata')
local tuple = cbox.replace_cdata(mktuple1(k))
print('tuple', tuple)
print('#tuple', #tuple)
print('tuple[1]', tuple:field(1))
print('tuple[2]', tuple:field(2))
print("")

print('Benchmark')
COUNT = 10000000
print(string.rep('-', 80))
print([[
Lua/C:
1. tuple = function(table) (using Lua/C)
2. Check table[1] == tuple[1] (using Lua/C to get field)

FFI:
1. str = ffimsgpack.encode(table)
2. tuple = function(str) (using FFI)
3. Check table[1] == tuple[1] (using ffimsgpack.decode to get field)
]])

print('count', COUNT)
print(' ')

local mktuple = mktuple1
ops_base = nil
bench(cbox.replace, mktuple, COUNT, "Lua/C + userdata")
bench(cbox.replace_cdata, mktuple, COUNT, "Lua/C + cdata")
bench(box.replace, mktuple, COUNT, "FFI + cdata")
bench(box.replace_nojit, mktuple, COUNT, "FFI + cdata JITOFF")
print('')

print('seq', builtin.seq)
