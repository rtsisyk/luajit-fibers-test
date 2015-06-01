package.path = "third_party/luajit-2.1/src/?.lua;"..package.path
require("jit.v").start("jit.txt")


