#!/usr/bin/lua


local s = "http://192.168.8.1/cgi-bin/luci"

local node

for node in string.gmatch(s,"[^/%z]+") do
    print(node)
end

