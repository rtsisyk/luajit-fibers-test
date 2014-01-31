project(luajit-fibers)
cmake_minimum_required(VERSION 2.8)

set(SRC_LIST
        main.cc
        box.cc
        tarantool/coro.cc
        tarantool/tbuf.c
        tarantool/lua/utils.c
        tarantool/lua/msgpack.cc
        third_party/coro/coro.c
        third_party/msgpuck/msgpuck.c
)

set(CMAKE_C_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS "-Wall -Wextra")
add_definitions("-DCORO_ASM")

add_definitions("-D__STDC_FORMAT_MACROS=1")
add_definitions("-D__STDC_LIMIT_MACROS=1")
add_definitions("-D__STDC_CONSTANT_MACROS=1")

set(LUAJIT_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/third_party/luajit-2.1/src")
set(LIBEIO_LIBRARIES "${CMAKE_SOURCE_DIR}/third_party/luajit-2.1/src/libluajit.a")

include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/third_party)
include_directories(${LUAJIT_INCLUDE_DIR})

add_executable(${PROJECT_NAME} ${SRC_LIST})
target_link_libraries(${PROJECT_NAME} dl ${LIBEIO_LIBRARIES})
