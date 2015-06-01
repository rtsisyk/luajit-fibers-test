project(luajit-fibers)
cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()

set(SRC_LIST
        main.cc
        tarantool/coro.cc
        third_party/coro/coro.c
)

set(CMAKE_C_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS "-Wall -Wextra")
add_definitions("-DCORO_ASM")

add_definitions("-D__STDC_FORMAT_MACROS=1")
add_definitions("-D__STDC_LIMIT_MACROS=1")
add_definitions("-D__STDC_CONSTANT_MACROS=1")

add_custom_target(build_bundled_libs)
set(MODULE_INCLUDEDIR ".")
include(luajit)

include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/third_party)
include_directories(${LUAJIT_INCLUDE_DIR})

add_executable(${PROJECT_NAME} ${SRC_LIST})
add_dependencies(${PROJECT_NAME} build_bundled_libs)

target_link_libraries(${PROJECT_NAME} ${LUAJIT_LIB} dl)
