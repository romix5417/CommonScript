#!/usr/bin/lua

require "debug"

local myfile = debug.getinfo(1, 'S').source:sub(2)
print(debug.getinfo(1,'S').source)
print(myfile)

print(arg[1])
print(arg[2])


